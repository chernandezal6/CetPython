using System;
using System.Data;
using SuirPlus;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas
{
	/// <summary>
	/// Nomina de empleador
	/// </summary>
	public class Nomina : FrameWork.Objetos 
	{

		//Atributos de un Empleador
		private int myRegistroPatronal,myIdNomina;

		private string myNominaDes,myEstatus,myTipoNomina;

		public Nomina(int registroPatronal, int idNomina)
		{
			this.myIdNomina = idNomina;
			this.myRegistroPatronal = registroPatronal;
			this.CargarDatos();
			
		}
		
		#region "  Propiedades de la Nomina  "

		
		public int RegistroPatronal
		{
			get
			{
				return this.myRegistroPatronal;
			}
		}

		public int IDNomina
		{
			get
			{
				return this.myIdNomina;
			}
		}

		public string NominaDes
		{
			get
			{
				return this.myNominaDes;
			}
			set
			{
				this.myNominaDes = value;
			}
		}

		public string Estatus
		{
			get
			{
				return this.myEstatus;
			}
			set
			{
				this.myEstatus = value;
			}
		}

		public string TipoNomina
		{
			get
			{
				return this.myTipoNomina;
			}
			set
			{
				this.myTipoNomina= value;
			}
		}

		#endregion

		#region "  Metodos sobrecargados  "

		public override void CargarDatos()
		{

			DataTable dt;
			dt = Nomina.getNomina(this.myRegistroPatronal,this.IDNomina);

			try
			{

				this.myRegistroPatronal = Int32.Parse(dt.Rows[0]["id_registro_patronal"].ToString());
				this.NominaDes = dt.Rows[0]["nomina_des"].ToString();
				this.TipoNomina = dt.Rows[0]["tipo_nomina"].ToString();
				this.Estatus = dt.Rows[0]["status"].ToString();
		
				dt.Dispose();

			}
			catch(Exception ex)
			{
				Exepciones.DataNoFoundException tmpException = new Exepciones.DataNoFoundException();
				tmpException.setMessage(ex.ToString());
				throw tmpException;
			}
 
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{

			OracleParameter[] orParam = new OracleParameter[7];

			orParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			orParam[0].Value = this.RegistroPatronal;
			orParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
			orParam[1].Value = this.IDNomina;
			orParam[2] = new OracleParameter("p_nomina_des", OracleDbType.NVarchar2);
			orParam[2].Value = this.NominaDes; 
			orParam[3] = new OracleParameter("p_status", OracleDbType.NVarchar2);
			orParam[3].Value = this.Estatus;
			orParam[4] = new OracleParameter("p_tipo_nomina", OracleDbType.NVarchar2);
			orParam[4].Value = this.TipoNomina;
			orParam[5] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2);
			orParam[5].Value = UsuarioResponsable;
			orParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			orParam[6].Direction = ParameterDirection.Output;


			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"sre_nominas_pkg.nominas_editar",orParam);	
				return orParam[6].Value.ToString();
			}

			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				return ex.ToString();
			}
		}
        public static DataTable GetNominaDiscapacitados(int id_nss, int id_Registro_Patronal)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
            arrParam[0].Value = id_nss;
            arrParam[1] = new OracleParameter("p_idRegistroPatronal", OracleDbType.Decimal);
            arrParam[1].Value = id_Registro_Patronal;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;
            
            string cmdStri = "Sre_Nominas_Pkg.getNominaDiscapacitados";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    throw new Exception("No hay Data");
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
        

		#endregion

		#region "  Funciones Estaticas de Validacion, Busqueda y Actualizaciones "
        
		public static string insertaNomina(int idRegistroPatronal,
			String nomDesc,
			String estatus, 
			String tipoNomina, 
			String usuario)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[0].Value = idRegistroPatronal;
			arrParam[1] = new OracleParameter("p_nomina_des", OracleDbType.NVarchar2, 40);
			arrParam[1].Value = nomDesc;
			arrParam[2] = new OracleParameter("p_status", OracleDbType.NVarchar2, 1);
			arrParam[2].Value = estatus;
			arrParam[3] = new OracleParameter("p_tipo_nomina", OracleDbType.NVarchar2, 1);
			arrParam[3].Value = tipoNomina;
			arrParam[4] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[4].Value = usuario;
			arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[5].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_nominas_pkg.nominas_crear";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[5].Value.ToString();			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}


		}

		
		public static string GuardarCambios(int idRegistroPatronal, int idNomina,
			String nomDesc,
			String estatus, 
			String tipoNomina, 
			String usuario)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[0].Value = idRegistroPatronal;
			arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
			arrParam[1].Value = idNomina;
			arrParam[2] = new OracleParameter("p_nomina_des", OracleDbType.NVarchar2, 40);
			arrParam[2].Value = nomDesc;
			arrParam[3] = new OracleParameter("p_status", OracleDbType.NVarchar2, 1);
			arrParam[3].Value = estatus;
			arrParam[4] = new OracleParameter("p_tipo_nomina", OracleDbType.NVarchar2, 1);
			arrParam[4].Value = tipoNomina;
			arrParam[5] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[5].Value = usuario;
			arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[6].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_nominas_pkg.nominas_editar";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[6].Value.ToString();			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}
            
		}


        public static DataSet getNominaPorRNC(string rnc)
        {

            OracleParameter[] arrParam = new OracleParameter[3];
            string cmdStr = "sre_nominas_pkg.getNominasPorRNC";

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

		public static DataTable getNomina(int idRegistroPatronal, int idNomina)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(idNomina);
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Value = Utilitarios.Utils.verificarNulo(idRegistroPatronal);
			arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_nominas_pkg.nominas_select";

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
	
		public static DataTable consultaNomina(int idRegistroPatronal)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(idRegistroPatronal);
			arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_nominas_pkg.Consulta_Trabajadores";

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
	
		/// <summary>
		/// Funcion utilizada para obtener el detalle de una nomina del empleador.
		/// </summary>
		/// <param name="idRegistroPatronal">El registro patronal del empleador.</param>
		/// <param name="idNomina">El codigo de la nomina que se desea obtener el detalle.</param>
		/// <returns> un datatable con el resultado de la consulta.</returns>
		/// <remarks>Creado por Ronny  J. Carreras 20/12/2004</remarks>
		public static DataTable getNominaDetalle(int idRegistroPatronal, int idNomina)
		{
			
			//TODO verificar lo que se va hacer con el parametro p_resultnumber.

			string strCmd = "sre_nominas_pkg.get_detalle_nomina";
	
			OracleParameter[] arrParam = new OracleParameter[4];
			
			arrParam[0] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
			arrParam[0].Value = idNomina;
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Value = idRegistroPatronal;
			arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			arrParam[3].Direction = ParameterDirection.Output;

			try
			{
				
			DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure,strCmd,arrParam);
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

        public static DataTable getNominaPorTipoYRegPat(int idRegistroPatronal, string Tipo_novedad)
        {

            //TODO verificar lo que se va hacer con el parametro p_resultnumber.

            string strCmd = "sre_nominas_pkg.getTipoNominasXEmpresas";

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;
            arrParam[1] = new OracleParameter("p_tipo_nomina", OracleDbType.NVarchar2);
            arrParam[1].Value = Tipo_novedad;
            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;

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
		
        public static DataTable getNomTrabCedCancel(int idRegistroPatronal, int idNomina)
		{
			
			//TODO verificar lo que se va hacer con el parametro p_resultnumber.

			string strCmd = "sre_nominas_pkg.get_Detalle_Ced_Cancelada";
	
			OracleParameter[] arrParam = new OracleParameter[4];
			
			arrParam[0] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
			arrParam[0].Value = idNomina;
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Value = idRegistroPatronal;
			arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			arrParam[3].Direction = ParameterDirection.Output;

			try
			{
				
				DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure,strCmd,arrParam);
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

	    public static string borraNomina(int idRegistroPatronal,int idNomina, String usuario )
		{

			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[0].Value = idRegistroPatronal;
			arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
			arrParam[1].Value = idNomina;
			arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[2].Value = usuario;
			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_nominas_pkg.nominas_borrar";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[3].Value.ToString();			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}

		}

        /// <summary>
     /// Metodo utilizado para obtener el detalle de una nomina
     /// </summary>
     ///<param name="regPatronal">Registro Patronal del empleador</param>
     ///<param name="nomina">Id de la nomina</param>
     ///<param name="pageNum">Numero de la pagina utilizado para el paging</param>
     ///<param name="pageSize">Tamaño de la pagina, utilizado para el paging</param>
     ///<returns>Un datatable con el detalle de la nomina especificada</returns>
     ///<remarks>By Ronny Carreras</remarks>  
        public static DataTable getDetalleNomina(int idRegistroPatronal, int Idnomina, string tipoCriterio, string criterio, Int16 pageNum, Int16 pageSize )
    {
       OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_id_nomina", OracleDbType.Decimal, 6);
            arrParam[0].Value = Idnomina;
            arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal, 9);
            arrParam[1].Value = idRegistroPatronal;
            arrParam[2] = new OracleParameter("p_tipo", OracleDbType.Varchar2, 1);
            arrParam[2].Value = tipoCriterio;
            arrParam[3] = new OracleParameter("p_criterio", OracleDbType.Varchar2, 30);
            arrParam[3].Value = criterio;
            arrParam[4] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[4].Value = pageNum;
            arrParam[5] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[5].Value = pageSize;
            arrParam[6] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;
            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[7].Direction = ParameterDirection.Output;

            string strCmd = "Sre_Nominas_Pkg.getPage_Detalle_Nomina";

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

        public static DataTable getTipoNomina()
        {

            OracleParameter[] arrParam = new OracleParameter[2];
            arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Nominas_Pkg.getTipoNominas";

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
        #endregion

	
		}
}
