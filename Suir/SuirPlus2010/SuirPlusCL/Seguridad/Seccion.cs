using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;
using SuirPlus.DataBase;


namespace SuirPlus.Seguridad
{
	/// <summary>
	/// Summary description for Seccion.
	/// </summary>
	public class Seccion : FrameWork.Objetos
	{

		private int myID_Seccion;
		private string myDescripcion;

		public Seccion(int ID_Seccion)
		{
			this.myID_Seccion = ID_Seccion;
			this.CargarDatos();
		}

		public int ID_Seccion
		{
			get{return this.myID_Seccion;}
		}
		public string Descripcion
		{
			set{this.myDescripcion = value;}
			get{return this.myDescripcion;}
		}


		public static DataTable getSecciones(int IDSeccion)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_seccion", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(IDSeccion);

			arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "seg_seccion_pkg.get_seccion";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				//throw ex;
				throw new Exception(arrParam[2].Value.ToString());
			}
		}

		public static String nuevaSeccion(string Descripcion, string UsuarioResponsable)
		{
			OracleParameter[] orParam = new OracleParameter[3];
			
			orParam[0] = new OracleParameter("p_seccion_des", OracleDbType.NVarchar2,40);
			orParam[0].Value = Descripcion;

			orParam[1] = new OracleParameter("p_ult_usuario_act",OracleDbType.NVarchar2,20);
			orParam[1].Value = UsuarioResponsable;

			orParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			orParam[2].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_seccion_pkg.seccion_crear",orParam);
				return orParam[2].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}

		}
		
		public static String borrarSeccion(int IDSeccion)
		{

			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_id_seccion", OracleDbType.Decimal);
			arrParam[0].Value = IDSeccion;

			arrParam[1] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 200);
			arrParam[1].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_seccion_pkg.seccion_borrar",arrParam);	
				return arrParam[1].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}
		}

		
		public override void CargarDatos()
		{
			DataTable dt;

			dt = getSecciones(this.myID_Seccion);

			this.myDescripcion = dt.Rows[0]["Seccion_Des"].ToString();

			dt.Dispose();
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{
			OracleParameter[] orParam = new OracleParameter[4];

			orParam[0] = new OracleParameter("p_id_seccion", OracleDbType.Decimal);
			orParam[0].Value = this.myID_Seccion;
			
			orParam[1] = new OracleParameter("p_seccion_des", OracleDbType.NVarchar2,50);
			orParam[1].Value = this.myDescripcion;

			orParam[2] = new OracleParameter("p_ult_usuario_act",OracleDbType.NVarchar2,20);
			orParam[2].Value = UsuarioResponsable;

			orParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			orParam[3].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"seg_seccion_pkg.seccion_editar",orParam);	
				return orParam[3].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}
		}


	}
}
