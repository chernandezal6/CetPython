using SuirPlus;
using System;
using SuirPlus.DataBase;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using System.Xml;
using System.IO;

namespace SuirPlus.Mantenimientos
{
    /// <summary>
    /// Clase para manejar todo lo relativo a los sectores salariales
    /// </summary>
    public class SectoresSalariales: SuirPlus.FrameWork.Objetos
    {
        //Para la tabla maestra SRE_SECTORES_ECONOMICOS_T
        private int myCod_Sector;
        private String myDescripcion;
        private DateTime myUlt_Fecha_Act;
        private String myUlt_Usuario_Act;

        //Propiedades públicas de la clase
        public int Cod_Sector
        {
            get { return this.myCod_Sector; }
            set { myCod_Sector = value; }
        }

        public String Descripcion
        {
            get { return this.myDescripcion; }
            set { this.myDescripcion = value; }
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
        public SectoresSalariales(int ID_Sector)
		{
			this.Cod_Sector = ID_Sector;
			this.CargarDatos();
		}

        //Métodos públicos y estático de la clase para la tabla maestra
        public static DataTable getSectorSalarial(int Cod_Sector)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_sector", OracleDbType.Int32);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(Cod_Sector);

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_SECTORES_SALARIALES_PKG.GetSectorSalarial";
            String result = String.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[0].Value.ToString();
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

        public static DataTable getSectoresSalariales()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_SECTORES_SALARIALES_PKG.GetSectoresSalariales";
            String result = String.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[0].Value.ToString();
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

        public static DataTable getEscalasSalariales(int Cod_Sector)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_cod_sector", OracleDbType.Int32);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(Cod_Sector);
     
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_SECTORES_SALARIALES_PKG.getescalassalariales";
            String result = String.Empty;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[2].Value.ToString();
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

        public override void CargarDatos()
		{
			DataTable dt = new DataTable();

			dt = getSectorSalarial(this.Cod_Sector);

            this.Cod_Sector = Convert.ToInt32(dt.Rows[0]["cod_sector"].ToString());
            this.Descripcion = dt.Rows[0]["descripcion"].ToString();
			this.Ult_Fecha_Act = Convert.ToDateTime(dt.Rows[0]["ult_fecha_act"].ToString());
			this.Ult_Usuario_Act = dt.Rows[0]["ult_usuario_act"].ToString();

			dt.Dispose();
		}

        public static string NuevoSectorSalarial(String p_descripcion, String p_ult_usuario_act)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_descripcion", OracleDbType.Varchar2, 250);
            arrParam[0].Value = p_descripcion;

            arrParam[1] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 35);
            arrParam[1].Value = p_ult_usuario_act;
            
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_SECTORES_SALARIALES_PKG.InsertSectorSalarial";
            String result = String.Empty;

            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();

                if (result.Substring(0, 1) != "0")
                    throw new Exception(result.Replace("0", ""));

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }

		public override String GuardarCambios(string usuarioActualiza)
		{

			OracleParameter[] arrParam = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_cod_sector", OracleDbType.Int32);
			arrParam[0].Value = this.Cod_Sector;

			arrParam[1] = new OracleParameter("p_descripcion", OracleDbType.Varchar2, 250);
			arrParam[1].Value = this.Descripcion;

			arrParam[2] = new OracleParameter("p_ult_fecha_act", OracleDbType.Date);
			arrParam[2].Value = this.Ult_Fecha_Act;
						
			arrParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 35);
			arrParam[3].Value = this.Ult_Fecha_Act;

			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SRE_SECTORES_SALARIALES_PKG.GuardarCambios";
			string result = string.Empty;
			
			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr,arrParam);
				result = arrParam[4].Value.ToString();

				if(result.Substring(0,1) != "0" )
					throw new Exception(result.Replace("0",""));											 
								
			}
			catch(Exception ex)
			{
				throw ex;
			}

			return result;
		}

        public static string NuevaEscalaSalarial(String p_cod_sector, String p_fecha_inicio, String p_fecha_fin, String p_salario_minimo, String p_ult_usuario_act)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_cod_sector", OracleDbType.Int32);
            if (p_cod_sector != string.Empty)
                arrParam[0].Value = Convert.ToInt32(p_cod_sector);

            arrParam[1] = new OracleParameter("p_fecha_ini", OracleDbType.Date);
            if (p_fecha_inicio != string.Empty)
                arrParam[1].Value = Convert.ToDateTime(p_fecha_inicio);

            arrParam[2] = new OracleParameter("p_fecha_fin", OracleDbType.Date);
            if (p_fecha_fin != string.Empty)
                arrParam[2].Value = Convert.ToDateTime(p_fecha_fin);

            arrParam[3] = new OracleParameter("p_salario_minimo", OracleDbType.Double);
            if (p_salario_minimo != string.Empty)
                arrParam[3].Value = Convert.ToDouble(p_salario_minimo);

            arrParam[4] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 35);
            arrParam[4].Value = p_ult_usuario_act;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_SECTORES_SALARIALES_PKG.InsertEscalaSalarial";
            String result = String.Empty;

            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[5].Value.ToString();

                if (result.Substring(0, 1) != "0")
                    throw new Exception(result.Replace("0", ""));

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }
    }
}
