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
    public class Turnos
    {
        #region Variables Privadas y Propiedades

        int v_id_turno;
        public int id_turno
        {
            get { return v_id_turno; }
        }

        int v_cod_turno;
        public int cod_turno
        {
            get { return v_cod_turno; }
            set { v_cod_turno = value; }
        }
        string v_descripcion;
        public string descripcion
        {
            get { return v_descripcion; }
            set { v_descripcion = value; }
        }

        int v_id_registro_patronal;
        public int id_registro_patronal
        {
            get { return v_id_registro_patronal; }
            set { v_id_registro_patronal = value; }
        }
        string v_trabajo_1_desde;
        public string trabajo_1_desde
        {
            get { return v_trabajo_1_desde; }
            set { v_trabajo_1_desde = value; }
        }
        string v_trabajo_1_hasta;
        public string trabajo_1_hasta
        {
            get { return v_trabajo_1_hasta; }
            set { v_trabajo_1_hasta = value; }
        }
        string v_descanso_1_desde;
        public string descanso_1_desde
        {
            get { return v_descanso_1_desde; }
            set { v_descanso_1_desde = value; }
        }
        string v_descanso_1_hasta;
        public string descanso_1_hasta
        {
            get { return v_descanso_1_hasta; }
            set { v_descanso_1_hasta = value; }
        }

        string v_trabajo_2_desde;
        public string trabajo_2_desde
        {
            get { return v_trabajo_2_desde; }
            set { v_trabajo_2_desde = value; }
        }
        string v_trabajo_2_hasta;
        public string trabajo_2_hasta
        {
            get { return v_trabajo_2_hasta; }
            set { v_trabajo_2_hasta = value; }
        }

        int v_descanso_dia_desde;
        public int descanso_dia_desde
        {
            get { return v_descanso_dia_desde; }
            set { v_descanso_dia_desde = value; }
        }

        string v_descanso_dia_desde_des;
        public string descanso_dia_desde_des
        {
            get { return v_descanso_dia_desde_des; }
            set { v_descanso_dia_desde_des = value; }
        }

        string v_descanso_hora_desde;
        public string descanso_hora_desde
        {
            get { return v_descanso_hora_desde; }
            set { v_descanso_hora_desde = value; }
        }

        int v_descanso_dia_hasta;
        public int descanso_dia_hasta
        {
            get { return v_descanso_dia_hasta; }
            set { v_descanso_dia_hasta = value; }
        }

        string v_descanso_dia_hasta_des;
        public string descanso_dia_hasta_des
        {
            get { return v_descanso_dia_hasta_des; }
            set { v_descanso_dia_hasta_des = value; }
        }
        string v_descanso_hora_hasta;
        public string descanso_hora_hasta
        {
            get { return v_descanso_hora_hasta; }
            set { v_descanso_hora_hasta = value; }
        }

        string v_ult_usuario_act;
        public string ult_usuario_act
        {
            get { return v_ult_usuario_act; }
            set { v_ult_usuario_act = value; }
        }

        string v_status;
        public string status {
            get { return v_status; }
            set { v_status = value; }
        }
        #endregion

        /// <summary>
        /// Constructor de la clase utilizada para crear un Turno.
        /// </summary>
        public Turnos()
        {

        }
        /// <summary>
        /// Constructor de la clase utilizada obtener toda la informacion concerniente a un Turno.
        /// </summary>
        public Turnos(int p_id_turno)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_MDT_PKG.getTurno";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_turno", OracleDbType.Int32);
            arrParam[0].Value = p_id_turno;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (ds.Tables.Count > 0)
                {
                    dt = ds.Tables[0];

                    v_id_turno = Convert.ToInt32(dt.Rows[0]["id_turno"]);
                    cod_turno = Convert.ToInt32(dt.Rows[0]["cod_turno"]);
                    descripcion = dt.Rows[0]["descripcion"].ToString();
                    id_registro_patronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"]);
                    trabajo_1_desde = Convert.ToDateTime(dt.Rows[0]["trabajo_1_desde"]).ToString("h:mm tt");
                    trabajo_1_hasta = Convert.ToDateTime(dt.Rows[0]["trabajo_1_hasta"]).ToString("h:mm tt");
                    if(dt.Rows[0]["descanso_1_desde"].ToString()!=string.Empty){
                      descanso_1_desde = Convert.ToDateTime(dt.Rows[0]["descanso_1_desde"]).ToString("h:mm tt");
                    }
                    if (dt.Rows[0]["descanso_1_hasta"].ToString() != string.Empty)
                    {
                        descanso_1_hasta = Convert.ToDateTime(dt.Rows[0]["descanso_1_hasta"]).ToString("h:mm tt");
                    }
                    if (dt.Rows[0]["trabajo_2_desde"].ToString() != string.Empty)
                    {
                        trabajo_2_desde = Convert.ToDateTime(dt.Rows[0]["trabajo_2_desde"]).ToString("h:mm tt");
                    }
                    if (dt.Rows[0]["trabajo_2_hasta"].ToString() != string.Empty)
                    {
                        trabajo_2_hasta = Convert.ToDateTime(dt.Rows[0]["trabajo_2_hasta"]).ToString("h:mm tt");
                    }  

                    descanso_dia_desde = Convert.ToInt32(dt.Rows[0]["descanso_dia_desde"]);
                    descanso_dia_desde_des = dt.Rows[0]["descanso_dia_desde_des"].ToString();
                    descanso_hora_desde = Convert.ToDateTime(dt.Rows[0]["descanso_hora_desde"]).ToString("h:mm tt");
                    descanso_dia_hasta = Convert.ToInt32(dt.Rows[0]["descanso_dia_hasta"]);
                    descanso_dia_hasta_des = dt.Rows[0]["descanso_dia_hasta_des"].ToString();
                    descanso_hora_hasta = Convert.ToDateTime(dt.Rows[0]["descanso_hora_hasta"]).ToString("h:mm tt");
                    status = dt.Rows[0]["status"].ToString();
                  //  ult_usuario_act = dt.Rows[0]["ult_usuario_act"].ToString();

                }
                else
                {
                    throw new Exception("No hay Data.");
                }

            }


            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable getTurnos(Int32 pIdRegistroPatronal, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam;

            String cmdStr = "SRE_MDT_PKG.getTurnos";

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

        public static DataTable listarTurnos(Int32 pIdRegistroPatronal)
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

            String cmdStr = "SRE_MDT_PKG.listarTurnos";
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

        public static string procesarTurno(int p_id_turno, int p_id_registro_patronal, string p_descripcion,
                                        string p_trabajo_1_desde, string p_trabajo_1_hasta, string p_descanso_1_desde, string p_descanso_1_hasta,
                                        string p_trabajo_2_desde, string p_trabajo_2_hasta, int p_descanso_dia_desde, string p_descanso_hora_desde, int p_descanso_dia_hasta,
                                        string p_descanso_hora_hasta,string ult_usuario_act,string p_status)
        {
            OracleParameter[] arrParam = new OracleParameter[16];
            try
            {
                arrParam[0] = new OracleParameter("p_id_turno", OracleDbType.Int32);
                if (p_id_turno != 0)
                {
                    arrParam[0].Value = Convert.ToInt32(p_id_turno);
                }
                else
                {
                    arrParam[0].Value = DBNull.Value;
                }


                arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
                if (p_id_registro_patronal != 0)
                {
                    arrParam[1].Value = Convert.ToInt32(p_id_registro_patronal);
                }
                else
                {
                    arrParam[1].Value = DBNull.Value;
                }
                
                arrParam[2] = new OracleParameter("p_descripcion", OracleDbType.Varchar2, 150);
                arrParam[2].Value = p_descripcion;

                arrParam[3] = new OracleParameter("p_trabajo_1_desde", OracleDbType.Date);
                    if (p_trabajo_1_desde != "")
                    {
                        arrParam[3].Value = Convert.ToDateTime(p_trabajo_1_desde);
                    }
                arrParam[4] = new OracleParameter("p_trabajo_1_hasta", OracleDbType.Date);
                    if (p_trabajo_1_hasta != "")
                    {
                        arrParam[4].Value = Convert.ToDateTime(p_trabajo_1_hasta);
                    }
                arrParam[5] = new OracleParameter("p_descanso_1_desde", OracleDbType.Date);
                    if (p_descanso_1_desde != "")
                    {
                        arrParam[5].Value = Convert.ToDateTime(p_descanso_1_desde);
                    }
                arrParam[6] = new OracleParameter("p_descanso_1_hasta", OracleDbType.Date);
                    if (p_descanso_1_hasta != "")
                    {
                        arrParam[6].Value = Convert.ToDateTime(p_descanso_1_hasta);
                    }

                arrParam[7] = new OracleParameter("p_trabajo_2_desde", OracleDbType.Date);
                    if (p_trabajo_2_desde != "")
                    {
                        arrParam[7].Value = Convert.ToDateTime(p_trabajo_2_desde);
                    }
                arrParam[8] = new OracleParameter("p_trabajo_2_hasta", OracleDbType.Date);
                    if (p_trabajo_2_hasta != "")
                    {
                        arrParam[8].Value = Convert.ToDateTime(p_trabajo_2_hasta);
                    }
                arrParam[9] = new OracleParameter("p_descanso_dia_desde", OracleDbType.Int32);
                    if (p_descanso_dia_desde != 0)
                    {
                        arrParam[9].Value = Convert.ToInt32(p_descanso_dia_desde);
                    }
                arrParam[10] = new OracleParameter("p_descanso_hora_desde", OracleDbType.Date);
                    if (p_descanso_hora_desde != "")
                    {
                        arrParam[10].Value = Convert.ToDateTime(p_descanso_hora_desde);
                    }
                arrParam[11] = new OracleParameter("p_descanso_dia_hasta", OracleDbType.Int32);
                    if (p_descanso_dia_hasta != 0)
                    {
                        arrParam[11].Value = Convert.ToInt32(p_descanso_dia_hasta);
                    }
                arrParam[12] = new OracleParameter("p_descanso_hora_hasta", OracleDbType.Date);
                    if (p_descanso_hora_hasta != "")
                    {
                        arrParam[12].Value = Convert.ToDateTime(p_descanso_hora_hasta);
                    }

                arrParam[13] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2);
                arrParam[13].Value = ult_usuario_act;

                arrParam[14] = new OracleParameter("p_status", OracleDbType.Varchar2);
                arrParam[14].Value = p_status;

                arrParam[15] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
                arrParam[15].Direction = ParameterDirection.Output;

                String cmdStr = "sre_mdt_pkg.actualizarturnos";
                string result = string.Empty;

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[15].Value.ToString();

                if (result != "0")
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

    }
}
