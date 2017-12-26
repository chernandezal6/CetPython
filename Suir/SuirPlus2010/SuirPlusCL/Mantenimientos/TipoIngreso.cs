using SuirPlus;
using System;
using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System.Xml;
using System.IO;

namespace SuirPlus.Mantenimientos
{
   public class TipoIngreso : SuirPlus.FrameWork.Objetos
    {

        //Propiedades Privadas
        private int myCod_Ingreso;
        private String myDescripcion;
        private String myEstatus;
        private DateTime myUlt_Fecha_Act;
        private String myUlt_Usuario_Act;

        //Propiedades públicas de la clase
        public int Cod_Ingreso
        {
            get { return this.myCod_Ingreso; }
            set { myCod_Ingreso = value; }
        }

        public String Descripcion
        {
            get { return this.myDescripcion; }
            set { this.myDescripcion = value; }
        }
        public String Estatus
        {
            get { return this.myEstatus; }
            set { this.myEstatus = value; }
        }

        public DateTime Ult_Fecha_Act
        {
            get { return this.myUlt_Fecha_Act; }
            set { this.myUlt_Fecha_Act = value; }
        }

        public String Ult_Usuario_Act
        {
            get { return this.myUlt_Usuario_Act; }
            set { this.myUlt_Usuario_Act = value; }
        }

        //Constructor de la Clase
        public TipoIngreso(int IdIngreso)
		{
            this.Cod_Ingreso = IdIngreso;
			this.CargarDatos();
		}

        public override void CargarDatos()
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_ingreso", OracleDbType.Int32);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(Cod_Ingreso);

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_trabajador_pkg.GetTipoIngreso";
            String result = String.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[0].Value.ToString();
                if (result.Substring(0, 1) != "0")
                    throw new Exception(result.Replace("0", ""));

                if (ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];
                    this.Cod_Ingreso = Convert.ToInt32(dt.Rows[0]["cod_ingreso"].ToString());
                    this.Descripcion = dt.Rows[0]["descripcion"].ToString();
                    this.Estatus = dt.Rows[0]["status"].ToString();
                    this.Ult_Fecha_Act = Convert.ToDateTime(dt.Rows[0]["ult_fecha_act"].ToString());
                    this.Ult_Usuario_Act = dt.Rows[0]["ult_usuario_act"].ToString();

                    dt.Dispose();

                }
                else
                {
                    throw new Exception("No Hay Data");
                }
            }

            catch (Exception ex)
            {

                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getAllTipoIngreso()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_ingreso", OracleDbType.Int32);
            arrParam[0].Value = DBNull.Value;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_trabajador_pkg.GetTipoIngreso";
            String result = String.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[1].Value.ToString();
                if (result.Substring(0, 1) != "0")
                    throw new Exception(result.Replace("0", ""));

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
        public static DataView getTiposIngreso()
        {

            // Crear un DataView,. Filtrar por campo STATUS 
            // Devuevle el DT con solamente los Activos....
            DataTable dt = new DataTable();
            dt = getAllTipoIngreso();
            DataView dv = new DataView(dt);

            if (dt.Rows.Count > 0)
            {
                dv.RowFilter = "status = 'A'";
            }
            return dv;
        }
        public static String NuevoTipoIngreso(int codIngreso,string descripcion,string status, string usuarioActualiza)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_cod_ingreso", OracleDbType.Int32);
            arrParam[0].Value = codIngreso;

            arrParam[1] = new OracleParameter("p_descripcion", OracleDbType.Varchar2, 250);
            arrParam[1].Value = descripcion;

            arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 35);
            arrParam[2].Value = usuarioActualiza;

            arrParam[3] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[3].Value = status;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "sre_trabajador_pkg.inserttipoingreso";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[4].Value.ToString();

                if (result.Substring(0, 1) != "0")
                    throw new Exception(result.Replace("0", ""));

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }

        public override string GuardarCambios(string UsuarioResponsable)
        {
            throw new NotImplementedException();
        }

    }
}
