using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus;
using SuirPlus.DataBase;
using System.Globalization;

namespace SuirPlus.Utilitarios
{
	/// <summary>
	/// Summary description for TSS..........
	/// </summary>
	public class TSS
	{
				/// <summary>
		/// Procedimiento utlizado para obtener los motivos no impresion del empleador
		/// </summary>
		/// <returns>Un datatable con dos columnas:
		/// ID_MOTIVO_NO_IMPRESION
		/// MOTIVO_NO_IMPRESION_DES
		/// </returns>
		public static DataTable getMotivoNoImpresion()
		{
			string cmdStr = "Sre_Empleadores_Pkg.Get_MotivoNoImpresion";
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;

			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,1000);
			arrParam[1].Direction = ParameterDirection.Output;


			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr,arrParam).Tables[0];
			}
			catch(Exception ex)
			{
			throw ex;
			}

		}


		/// <summary>
		/// Optener los sectores economicos del sistema
		/// </summary>
		/// <param name="idSectorEconomico"></param>
		/// <returns></returns>
		public static DataTable getSectoresEconomicos(Int32 idSectorEconomico)
		{

			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("pID_SECTOR_ECONOMICO", OracleDbType.Decimal,11);
			if (idSectorEconomico != -1) arrParam[0].Value = idSectorEconomico;
			arrParam[1] = new OracleParameter("IO_CURSOR", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			String cmdStr= "SRE_GET_SECTOR_ECONOMICO_PKG.SRE_GET_SECTOR_ECONOMICO_SP";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}


		/// <summary>
		/// Optener todas las provincias
		/// </summary>
		/// <param name="idSectorEconomico"></param>
		/// <returns></returns>
		public static DataTable getProvincias()
		{

			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("pID_PROVINCIA",OracleDbType.Decimal);
			arrParam[0].Value = DBNull.Value;
			arrParam[1] = new OracleParameter("IO_CURSOR", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			String cmdStr= "Sre_Get_Provincias_Pkg.SRE_GET_PROVINCIAS_SP";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}
	

		public static string getProvinciaId(string municipioId)
		{
			DataTable tmpDt  = getMunicipios("",municipioId);
			try
			{
				return tmpDt.Rows[0]["id_provincia"].ToString();
			}
			catch(Exception ex)
			{
				return "-1";
			}

		}

		/// <summary>
		/// Optener todas las provincias
		/// </summary>
		/// <param name="idSectorEconomico"></param>
		/// <returns></returns>
		public static DataTable getMunicipios(string provinciaId, string municipioId)
		{

			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_provincia",OracleDbType.NVarchar2,6);
			arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(provinciaId);
			arrParam[1] = new OracleParameter("p_id_municipio",OracleDbType.NVarchar2,6);
			arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(municipioId);
			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,200);
			arrParam[3].Direction = ParameterDirection.Output;

			String cmdStr= "Sre_Get_Provincias_Pkg.GET_MUNICIPIO";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		/// <summary>
		/// Optener los municipios con sus respectivas provincias
		/// </summary>
		/// <param name="idSectorEconomico"></param>
		/// <returns></returns>
		public static DataTable getMunicipiosProvincias()
		{

			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("IO_CURSOR", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;

			String cmdStr= "SRE_GET_MUN_PROV_PKG.SRE_GET_MUN_PROV_SP";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		// Consulta de Nss
		public static DataTable getConsultaNss(string nodocumento, string idnss, 
			string nombres, string primerapellido, string segundoapellido, int pageNum, Int16 pageSize )
		{
			

			//throw new Exception(numerolote.ToString() + fechaIni.ToString() + fechaFin.ToString());

			OracleParameter[] arrParam  = new OracleParameter[9];

			arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 20);
			arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(nodocumento);

			arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Int32);
			arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idnss);

			arrParam[2] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
			arrParam[2].Value = nombres;

			arrParam[3] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 50);
			arrParam[3].Value = primerapellido;

			arrParam[4] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 50);
			arrParam[4].Value = segundoapellido;

			arrParam[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2,1000);
			arrParam[5].Direction = ParameterDirection.Output;

			arrParam[6] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[6].Value = pageNum;

            arrParam[7] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[7].Value = pageSize;

            arrParam[8] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[8].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_CIUDADANO_PKG.pageConsulta_Nss";

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

            //try
            //{
            //    return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            //}
            //catch(Exception ex)
            //{
            //    throw ex;
            //}
		}
        
        // CHK Empleador
		public static DataTable getEmpleadorDatos(string rnc)
		{
			

			//throw new Exception(numerolote.ToString() + fechaIni.ToString() + fechaFin.ToString());

			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2,11);
			arrParam[0].Value = rnc;
			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "Sre_Empleadores_Pkg.empleadores_rnc_select";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

		/// <summary>
		/// Utilizado para obtener el nombre de un ciudadano.
		/// </summary>
		/// <param name="tipoDocumento">Tipo de documento ya sea cedula o pasaporte</param>
		/// <param name="documento">No. de documento de identidad</param>
		/// <remarks>By Ronny Carreras</remarks>
		/// <returns>El nombre completo del ciudadano.</returns>
		public static string getNombreCiudadano(string tipoDocumento, string documento)
		{
			OracleParameter[] arrParam = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_tipo", OracleDbType.NVarchar2, 1);
			arrParam[0].Value = tipoDocumento;

			arrParam[1] = new OracleParameter("p_documento", OracleDbType.NVarchar2, 25);
			arrParam[1].Value = documento;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SEL_SOLICITUDES_PKG.getNombreCiudadano";
			string result = string.Empty;

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				result = arrParam[2].Value.ToString();
			}
			catch(Exception ex)
			{
				throw ex;
			}

			return result;
		}


		public static String consultaCiudadano(String tipoDoc, String documento)
		{

			OracleParameter[] arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_NumeroDocumento", OracleDbType.NVarchar2,25);
			arrParam[0].Value = documento;
			arrParam[1] = new OracleParameter("p_TipoDocumento", OracleDbType.NVarchar2,1);
			arrParam[1].Value = tipoDoc;
			arrParam[2] = new OracleParameter("p_Nombres", OracleDbType.NVarchar2,50);
			arrParam[2].Direction = ParameterDirection.Output;
			arrParam[3] = new OracleParameter("p_Apellidos", OracleDbType.NVarchar2,100);
			arrParam[3].Direction = ParameterDirection.Output;
			arrParam[4] = new OracleParameter("p_NSS", OracleDbType.Decimal,10);
			arrParam[4].Direction = ParameterDirection.Output;
			arrParam[5] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2,200);
			arrParam[5].Direction = ParameterDirection.Output;

			String cmdStr= "SRE_CIUDADANO_PKG.verificar_ciudadano_existe";
				
			DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

			// Preparando retorno del metodo con la siguiente estructura
			// RETORNO|NOMBRES|APELLIDOS|NSS
			
			String nombres, apellidos,nss;
			

			try
			{
				//Si el individuo fue encontrado
				if(arrParam[5].Value.ToString() == "0")
				{
					//retorno = (arrParam[5].Value.ToString()=="0"?arrParam[5].Value.ToString()+"||":arrParam[5].Value.ToString()+"|"); 
					//Este replace fue creado para evitar los nombres que contengan "|"
                    nombres = arrParam[2].Value.ToString().Replace("|","") + "|";
                    apellidos = arrParam[3].Value.ToString().Replace("|", "") + "|";
					nss = arrParam[4].Value.ToString();
					return "0|" + nombres + apellidos +  nss;
				}
				else
				{
					return arrParam[5].Value.ToString();
				}
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		public static DataTable CedulaCancelada(String noDoc)			
		{
			
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_NumeroDocumento", OracleDbType.NVarchar2, 25);
			arrParam[0].Value = noDoc;
			arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
				
			String cmdStr= "SRE_CIUDADANO_PKG.CedulaCancelada";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
	
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

        public static DataTable getCiudadanoValido( String documento, String tipoDoc)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_nodocumento", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = documento;
            arrParam[1] = new OracleParameter("p_TipoDocumento", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = tipoDoc;
            arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "Oficina_Virtual_pkg.Get_ciudadano_valido";
            
           try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getCiudadanoAsigNSS(String tipoDoc, String documento)
        {

            OracleParameter[] arrParam = new OracleParameter[4];
            
            arrParam[0] = new OracleParameter("p_Tipo", OracleDbType.NVarchar2, 1);
            arrParam[0].Value = tipoDoc;
            arrParam[1] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 25);
            arrParam[1].Value = documento;
            arrParam[2] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "nss_get_ciudadano";        
           
            try
            {
                DataTable dt = null;  
              dt =  DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    return dt;
                }
                return dt;
            }

            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getSectoresEconomicos()
		{
			return TSS.getSectoresEconomicos(-1);
		}
		

		/// <summary>
		/// Funcion utilizada para verificar si existe un ciudadano valido.
		/// </summary>
		/// <param name="tipoDoc">Tipo de documento</param>
		/// <param name="documento">Nro. de documento</param>
		/// <returns>true o false dependiendo si existe el ciudadano.</returns>
		public static bool existeCiudadano(string tipoDoc, string documento)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_nrodocumento", OracleDbType.NVarchar2,25);
			arrParam[0].Value = documento;

			arrParam[1] = new OracleParameter("p_tipodocumento", OracleDbType.NVarchar2,1);
			arrParam[1].Value = tipoDoc;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,100);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr = "Sre_Ciudadano_Pkg.IsExisteCiudadano";
			string result = string.Empty;

			try
			{			
			
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				result = arrParam[2].Value.ToString();	

				if (result == "1")
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}
		
       public static string insertaCiudadano(String tipoDoc,
			String noDoc,
			String nombres,
			String apellidoMat, 
			String apellidoPat, 
			String sexo, 
			String fechaNac,
			String usuario)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[9];

			arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
			arrParam[0].Value = nombres;
			arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2,40);
			arrParam[1].Value = apellidoPat;
			arrParam[2] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
			arrParam[2].Value = apellidoMat;
			arrParam[3] = new OracleParameter("p_fecha_nacimiento", OracleDbType.NVarchar2, 10);
			arrParam[3].Value = fechaNac;
			arrParam[4] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
			arrParam[4].Value = sexo;
			arrParam[5] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 25);
			arrParam[5].Value = noDoc;
			arrParam[6] = new OracleParameter("p_tipo_documento", OracleDbType.NVarchar2, 1);
			arrParam[6].Value = tipoDoc;
			arrParam[7] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[7].Value = usuario;
			arrParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[8].Direction = ParameterDirection.Output;
				
			String cmdStr= "SRE_CIUDADANO_PKG.ciudadano_crear";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[8].Value.ToString();			
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		/// <summary>
		/// Funcion utilizada para retornar la descripcion de un error.
		/// </summary>
		/// <param name="codigoError">un entero que representa el codigo de error.</param>
		/// <remarks>Autor: Ronny J. Carreras, Fecha: 09/11/2004</remarks>
		/// <returns>La descripcion de un código de error dado.</returns>
		public static string getErrorDescripcion(int codigoError)
		{	
		
				string mensaje;
				string resultado;
                string idError;           


                idError = Convert.ToString(codigoError);
               
				OracleParameter[] arrParam = new OracleParameter[3];
					
				arrParam[0] = new OracleParameter("pId_Error", OracleDbType.Varchar2);
                arrParam[0].Value = idError;

				arrParam[1] = new OracleParameter("pDesc_Error", OracleDbType.NVarchar2, 200);
				arrParam[1].Direction = ParameterDirection.Output;

				arrParam[2] = new OracleParameter("pResult", OracleDbType.NVarchar2, 200);
				arrParam[2].Direction = ParameterDirection.Output;

				try
				{
                    OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "Suirplus.SEG_GET_DESCRIPCION_ERROR_SP", arrParam);
					resultado = arrParam[2].Value.ToString();
				}
				catch(Exception ex)
				{
					//TODO:manejar la exepcion aquí
					throw ex;
				}	
		
			if(resultado == "0")
			{
				mensaje = arrParam[1].Value.ToString();
				return mensaje;
			}
			else
			{
					//TODO: manejar la excepcion aqui.
				mensaje = resultado;
				throw new Exception(mensaje);
			}
		}

		public static string getRegistroPatronal(string RNCoCedula)
		{
			string resultado;
			OracleParameter[] arrParam = new OracleParameter[2];
					
			arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2,11);
			arrParam[0].Value = RNCoCedula;

			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,200);
			arrParam[1].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"sre_empleadores_pkg.getRegistroPatronal",arrParam);
				resultado = arrParam[1].Value.ToString();
			}
			catch(Exception ex)
			{
				throw ex;
			}	

			return resultado;
		}

        public static string getRegistroPatronalActivo(string RNCoCedula)
        {
            string resultado;
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNCoCedula;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sre_empleadores_pkg.getRegistroPatronalActivo", arrParam);
                resultado = arrParam[1].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return resultado;
        }

        public static DateTime getUltimoPeriodoRegargos()
		{
			DateTime resultado;
			OracleParameter[] arrParam = new OracleParameter[1];

            arrParam[0] = new OracleParameter("p_periodo_recargo", OracleDbType.NVarchar2, 10);
			arrParam[0].Direction = ParameterDirection.Output;

			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"Ofc_Oficios_Pkg.Get_Periodo_Recargo",arrParam);
                DateTime fechaParametro = new DateTime();
                if (arrParam[0].Value.ToString() != string.Empty) 
                {
                    fechaParametro = Convert.ToDateTime(arrParam[0].Value.ToString()).Date;
                }
                resultado = fechaParametro;
			}
			catch(Exception ex)
			{
				throw ex;
			}

			return resultado;

		}

		// Consulta de dependiente
		public static DataTable getDependienteAdicional(string Cedula, string Idnss)
		{

			OracleParameter[] arrParam  = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.NVarchar2, 20);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Idnss);
            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 20);
			arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Cedula);
			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;

			String cmdStr= "SRE_TRABAJADOR_PKG.Get_DependienteAdicional";
			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}


		// Consulta el titular del dependiente
		public static DataTable getTitular(string Cedula, string Idnss)
		{

			OracleParameter[] arrParam  = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.NVarchar2, 20);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Idnss);
            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 20);
			arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Cedula);
			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;
		
			String cmdStr= "SRE_TRABAJADOR_PKG.Get_Titular";
			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

        public static DataTable get_Municipios()
		{

			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("IO_CURSOR", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;

            String cmdStr = "sre_get_municipio_pkg.get_municipio_sp";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

        public static DataTable get_Nacionalidades()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("IO_CURSOR", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;


            String cmdStr = "sre_ciudadano_pkg.getNacionalidad";

            try
            {
               return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable get_Oficialis_Municipios(string municipioId)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("pID_MUNICIPIO", OracleDbType.Double);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(municipioId);
            arrParam[1] = new OracleParameter("IO_Cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;


            String cmdStr = "SRE_GET_MUNICIPIO_PKG.SRE_GET_OFICILIA_MUNICIPIO_SP";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

	

        //***** Milciades Hernandez 14/01/2010 ******
        //***** Función para modificar datos Ciudadanos menores de edad ******


        public static string InsertarCiudadanoAct(
            int idNss,
            String noDoc,
            String nombres,
            String apellidoMat,
            String apellidoPat,
            String sexo,
            DateTime feNac,
            String usuario
            )
        {

            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Double);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idNss);
            arrParam[1] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 25);
            arrParam[1].Value = noDoc;              
            arrParam[2] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
            arrParam[2].Value = nombres;
            arrParam[3] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
            arrParam[3].Value = apellidoPat;
            arrParam[4] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
            arrParam[4].Value = apellidoMat;
            arrParam[5] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
            arrParam[5].Value = feNac;
            arrParam[6] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
            arrParam[6].Value = sexo;
            arrParam[7] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[7].Value = usuario;
            arrParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[8].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_CIUDADANO_PKG.Insertar_Ciudadano_act";

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

        // agregar el idNSS para la busqueda ya no se hara por nodocumento..
        public static DataTable getconsultaCiudadanoAct(String idnss, out String result)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idnss);
            
            //arrParam[0] = new OracleParameter("p_numerodocumento", OracleDbType.Varchar2);
            //arrParam[0].Value = documento;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            
            string cmdStri = "Sre_Ciudadano_Pkg.getconsultaciudadanoact";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                result = arrParam[1].Value.ToString();
                
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    return new DataTable();
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        // agrar el cambio con el idNSS y no con el nodocumento.
         public static DataTable getconsultaCiudadanoCambio(String idnss, out String result)
         {

             OracleParameter[] arrParam = new OracleParameter[3];

             arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
             arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idnss);

             arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[1].Direction = ParameterDirection.Output;

             arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[2].Direction = ParameterDirection.Output;


             string cmdStri = "Sre_Ciudadano_Pkg.getconsultaciudcambio";

             try
             {
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                 result = arrParam[1].Value.ToString();

                 if (result != "0") 
                 
                 {
                     throw new Exception(result);
                 } 
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

         public static string ActualizarCiudadano(String tipoDoc,
            String noDoc,
            String idNss,
            String nombres,
            String apellidoMat,
            String apellidoPat,
            String sexo,
            DateTime feNac,
            String usuario
            )
         {

             OracleParameter[] arrParam = new OracleParameter[10];


             arrParam[0] = new OracleParameter("p_nombres", OracleDbType.NVarchar2, 50);
             arrParam[0].Value = nombres;
             arrParam[1] = new OracleParameter("p_primer_apellido", OracleDbType.NVarchar2, 40);
             arrParam[1].Value = apellidoPat;
             arrParam[2] = new OracleParameter("p_segundo_apellido", OracleDbType.NVarchar2, 40);
             arrParam[2].Value = apellidoMat;
             arrParam[3] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
             arrParam[3].Value = feNac;
             arrParam[4] = new OracleParameter("p_sexo", OracleDbType.NVarchar2, 1);
             arrParam[4].Value = sexo;
             arrParam[5] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 25);
             arrParam[5].Value = noDoc;
             arrParam[6] = new OracleParameter("p_id_nss", OracleDbType.Int32);
             arrParam[6].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idNss);
             arrParam[7] = new OracleParameter("p_tipo_documento", OracleDbType.NVarchar2, 1);
             arrParam[7].Value = tipoDoc;
             arrParam[8] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
             arrParam[8].Value = usuario;
             arrParam[9] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[9].Direction = ParameterDirection.Output;

             String cmdStr = "SRE_CIUDADANO_PKG.Aplicar_Ciudadano";

             try
             {
                 DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                 return arrParam[9].Value.ToString();
             }
             catch (Exception ex)
             {
                 throw ex;
             }

         }

        
        
        public static string AplicarCambioCiudadano(String secuencia
                )
         {

             OracleParameter[] arrParam = new OracleParameter[2];


             arrParam[0] = new OracleParameter("p_sequence", OracleDbType.Int32);
             arrParam[0].Value = secuencia;
             
             arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[1].Direction = ParameterDirection.Output;

             String cmdStr = "SRE_CIUDADANO_PKG.Aplicar_Ciudadano";

             try
             {
                 DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                 return arrParam[1].Value.ToString();
             }
             catch (Exception ex)
             {
                 Exepciones.Log.LogToDB(ex.ToString());
                 throw ex;
             }

         }

         public static DataTable getCiudadano()
        {

            OracleParameter[] arrParam = new OracleParameter[2];
            arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;


            string cmdStri = "Sre_Ciudadano_Pkg.buscarciudadanos";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                //string result = arrParam[1].Value.ToString();
                
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


        //para procesar ciudadanos directamente desde la JCE

         public static string procesarCiudadano(string nro_documento, string nombres,string primer_apellido, string segundo_apellido,
                                                          string estado_civil, string fecha_nacimiento,string sexo, string id_tipo_sangre,
                                                          string id_nacionalidad, string nombre_padre, string nombre_madre, string id_municipio_acta,
                                                          string oficialia_acta, string libro_acta,string folio_acta, string numero_acta, string ano_acta, string tipo_causa, 
                                                          string id_causa_inhabilidad, string status, string ult_usuario_act,string accion,string fechaCancelacion,string nss)
         {

             OracleParameter[] arrParam = new OracleParameter[25];

             arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.Varchar2, 25);
             arrParam[0].Value = nro_documento;
             arrParam[1] = new OracleParameter("p_nombres", OracleDbType.Varchar2, 50);
             arrParam[1].Value = nombres;
             arrParam[2] = new OracleParameter("p_primer_apellido", OracleDbType.Varchar2, 40);
             arrParam[2].Value = primer_apellido;
             arrParam[3] = new OracleParameter("p_segundo_apellido", OracleDbType.Varchar2, 40);
             arrParam[3].Value = segundo_apellido;
             arrParam[4] = new OracleParameter("p_estado_civil", OracleDbType.Varchar2);
             arrParam[4].Value = estado_civil;
             arrParam[5] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
            if(fecha_nacimiento != null)
            {
                arrParam[5].Value = Convert.ToDateTime(fecha_nacimiento);
            }
            else
            {
            arrParam[5].Value = DBNull.Value;
            }             
             arrParam[6] = new OracleParameter("p_sexo", OracleDbType.Varchar2);
             arrParam[6].Value = sexo;
             arrParam[7] = new OracleParameter("p_id_tipo_sangre", OracleDbType.Varchar2);
             arrParam[7].Value = id_tipo_sangre;
             arrParam[8] = new OracleParameter("p_id_nacionalidad", OracleDbType.Varchar2);
             arrParam[8].Value = id_nacionalidad;
             arrParam[9] = new OracleParameter("p_nombre_padre", OracleDbType.Varchar2);
             arrParam[9].Value = nombre_padre;
             arrParam[10] = new OracleParameter("p_nombre_madre", OracleDbType.Varchar2);
             arrParam[10].Value = nombre_madre;
             arrParam[11] = new OracleParameter("p_municipio_acta", OracleDbType.Varchar2);
             arrParam[11].Value = id_municipio_acta;
             arrParam[12] = new OracleParameter("p_oficialia_acta", OracleDbType.Varchar2);
             arrParam[12].Value = oficialia_acta;
             arrParam[13] = new OracleParameter("p_libro_acta", OracleDbType.Varchar2);
             arrParam[13].Value = libro_acta;
             arrParam[14] = new OracleParameter("p_folio_acta", OracleDbType.Varchar2);
             arrParam[14].Value = folio_acta;
             arrParam[15] = new OracleParameter("p_numero_acta", OracleDbType.Varchar2);
             arrParam[15].Value = numero_acta;
             arrParam[16] = new OracleParameter("p_ano_acta", OracleDbType.Varchar2);
             arrParam[16].Value = ano_acta;
             arrParam[17] = new OracleParameter("p_tipo_causa", OracleDbType.Varchar2);
             arrParam[17].Value = tipo_causa;
             arrParam[18] = new OracleParameter("p_id_causa_inhabilidad", OracleDbType.Int32);
             if (id_causa_inhabilidad != "")
             {
                 arrParam[18].Value = Convert.ToInt32(id_causa_inhabilidad);
             }  
             arrParam[19] = new OracleParameter("p_status", OracleDbType.Varchar2);
             arrParam[19].Value = status;
             arrParam[20] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 35);
             arrParam[20].Value = ult_usuario_act;
             arrParam[21] = new OracleParameter("p_accion", OracleDbType.Varchar2, 1);
             arrParam[21].Value = accion;
             arrParam[22] = new OracleParameter("p_fecha_cancelacion", OracleDbType.Date);
             if (fechaCancelacion != null)
             {
                 arrParam[22].Value = Convert.ToDateTime(fechaCancelacion);
             }
             else
             {
                 arrParam[22].Value = DBNull.Value;
             }             

             arrParam[23] = new OracleParameter("p_nss", OracleDbType.Int64);
             if (nss != "")
             { 
                 arrParam[23].Value = Convert.ToInt64(nss);
             }

             arrParam[24] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[24].Direction = ParameterDirection.Output;

             String cmdStr = "SRE_CIUDADANO_PKG.procesarciudadano";

             try
             {
                 DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                 return arrParam[24].Value.ToString();
             }
             catch (Exception ex)
             {
                 throw ex;
             }

         }

         public static DataTable getCiudadano(string documento, string nombres,string primer_apellido, string segundo_apellido,string fecha_nacimiento,
                                              string municipio_acta,string ano_acta, string folio_acta, string numero_acta, string libro_acta, string oficialia_acta)
         {

             OracleParameter[] arrParam = new OracleParameter[13];
             arrParam[0]= new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 11);
             arrParam[0].Value=documento;

             arrParam[1]= new OracleParameter("p_nombres", OracleDbType.Varchar2);
             arrParam[1].Value=nombres;

             arrParam[2]= new OracleParameter("p_primer_apellido", OracleDbType.Varchar2);
             arrParam[2].Value=primer_apellido;

             arrParam[3]= new OracleParameter("p_segundo_apellido", OracleDbType.Varchar2);
             arrParam[3].Value=segundo_apellido;

             arrParam[4]= new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
             if (fecha_nacimiento != string.Empty)
             {
                 arrParam[4].Value = Convert.ToDateTime(fecha_nacimiento);
             }
             else
             {
                 arrParam[4].Value = DBNull.Value;
             }
             arrParam[5] = new OracleParameter("p_municipio_acta", OracleDbType.Varchar2);
             arrParam[5].Value = municipio_acta;

             arrParam[6] = new OracleParameter("p_ano_acta", OracleDbType.Varchar2);
             arrParam[6].Value = ano_acta;

             arrParam[7] = new OracleParameter("p_numero_acta", OracleDbType.Varchar2);
             arrParam[7].Value = numero_acta;

             arrParam[8] = new OracleParameter("p_folio_acta", OracleDbType.Varchar2);
             arrParam[8].Value = folio_acta;

             arrParam[9] = new OracleParameter("p_libro_acta", OracleDbType.Varchar2);
             arrParam[9].Value = libro_acta;

             arrParam[10] = new OracleParameter("p_oficilia_acta", OracleDbType.Varchar2);
             arrParam[10].Value = oficialia_acta;

             arrParam[11] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[11].Direction = ParameterDirection.Output;

             arrParam[12] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 800);
             arrParam[12].Direction = ParameterDirection.Output;

             string cmdStri = "Sre_Ciudadano_Pkg.getCiudadano";

             try
             {
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                 string result = arrParam[12].Value.ToString();
                 if (result == "0")
                 {
                     if (ds.Tables.Count > 0)
                     {
                         return ds.Tables[0];
                     }
                     else
                     {
                         return new DataTable();
                     }
                 }
                 else
                 {
                     throw new Exception(result);
                 }
             }

             catch (Exception ex)
             {
                 Exepciones.Log.LogToDB(ex.ToString());
                 throw ex;
             }
         }

         public static DataTable getCiudadanoNSS(Int32 idNss)
         {

             OracleParameter[] arrParam = new OracleParameter[3];
             arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
             arrParam[0].Value = idNss;

             arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[1].Direction = ParameterDirection.Output;

             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 800);
             arrParam[2].Direction = ParameterDirection.Output;

             string cmdStri = "Sre_Ciudadano_Pkg.getCiudadanoNSS";

             try
             {
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                 string result = arrParam[2].Value.ToString();
                 if (result == "0")
                 {
                     if (ds.Tables.Count > 0)
                     {
                         return ds.Tables[0];
                     }
                     else
                     {
                         return new DataTable();
                     }
                 }
                 else
                 {
                     throw new Exception(result);
                 }
             }

             catch (Exception ex)
             {
                 Exepciones.Log.LogToDB(ex.ToString());
                 throw ex;
             }
         }

        /// <summary>
        /// Este metodo:
        /// * Primero busca el ciudadano por el nro de documento para ver si hay una coincidencia de 1 a 1 con su Cedula.
        /// * Luego busca las coincidencias de acuerdo a las validaciones que esten encendidas para el proceso J4.s
        /// </summary>
        /// <param name="documento"></param>
        /// <param name="nombres"></param>
        /// <param name="primer_apellido"></param>
        /// <param name="segundo_apellido"></param>
        /// <param name="fecha_nacimiento"></param>
        /// <param name="sexo"></param>
        /// <param name="municipio_acta"></param>
        /// <param name="ano_acta"></param>
        /// <param name="folio_acta"></param>
        /// <param name="numero_acta"></param>
        /// <param name="libro_acta"></param>
        /// <param name="oficialia_acta"></param>
        /// <returns>Retorna un Dataset con los NSS que coinciden</returns>
         public static DataTable getCiudadanoDup(string documento, string nombres, string primer_apellido, string segundo_apellido, string fecha_nacimiento, string sexo,
                                      string municipio_acta, string ano_acta, string folio_acta, string numero_acta, string libro_acta, string oficialia_acta)
         {
             OracleParameter[] arrParam = new OracleParameter[14];
             arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 11);
             arrParam[0].Value = documento;

             arrParam[1] = new OracleParameter("p_nombres", OracleDbType.Varchar2);
             arrParam[1].Value = nombres;

             arrParam[2] = new OracleParameter("p_primer_apellido", OracleDbType.Varchar2);
             arrParam[2].Value = primer_apellido;

             arrParam[3] = new OracleParameter("p_segundo_apellido", OracleDbType.Varchar2);
             arrParam[3].Value = segundo_apellido;

             arrParam[4] = new OracleParameter("p_fecha_nacimiento", OracleDbType.Date);
             if (fecha_nacimiento != string.Empty)
             {
                 arrParam[4].Value = Convert.ToDateTime(fecha_nacimiento);
             }
             else
             {
                 arrParam[4].Value = DBNull.Value;
             }
             arrParam[5] = new OracleParameter("p_sexo", OracleDbType.Varchar2);
             arrParam[5].Value = sexo;

             arrParam[6] = new OracleParameter("p_municipio_acta", OracleDbType.Varchar2);
             arrParam[6].Value = municipio_acta;

             arrParam[7] = new OracleParameter("p_ano_acta", OracleDbType.Varchar2);
             arrParam[7].Value = ano_acta;

             arrParam[8] = new OracleParameter("p_numero_acta", OracleDbType.Varchar2);
             arrParam[8].Value = numero_acta;

             arrParam[9] = new OracleParameter("p_folio_acta", OracleDbType.Varchar2);
             arrParam[9].Value = folio_acta;

             arrParam[10] = new OracleParameter("p_libro_acta", OracleDbType.Varchar2);
             arrParam[10].Value = libro_acta;

             arrParam[11] = new OracleParameter("p_oficilia_acta", OracleDbType.Varchar2);
             arrParam[11].Value = oficialia_acta;

             arrParam[12] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[12].Direction = ParameterDirection.Output;

             arrParam[13] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 800);
             arrParam[13].Direction = ParameterDirection.Output;

             string cmdString = "Sre_Ciudadano_Pkg.getCiudadanoDup";

             try
             {
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdString, arrParam);
                 string result = arrParam[13].Value.ToString();
                 if (result == "0")
                 {
                     if (ds.Tables.Count > 0)
                     {
                         return ds.Tables[0];
                     }
                     else
                     {
                         return new DataTable();
                     }
                 }
                 else
                 {
                     throw new Exception(result);
                 }
             }

             catch (Exception ex)
             {
                 Exepciones.Log.LogToDB(ex.ToString());
                 throw ex;
             }
         }

         public static DataTable getWS_JCE_Parametros(string id_modulo)
         {

             OracleParameter[] arrParam = new OracleParameter[3];
             arrParam[0] = new OracleParameter("p_id_modulo", OracleDbType.NVarchar2, 11);
             arrParam[0].Value = id_modulo;
             arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[1].Direction = ParameterDirection.Output;
             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[2].Direction = ParameterDirection.Output;


             string cmdStri = "Sre_Ciudadano_Pkg.getWS_JCE_Parametros";

             try
             {
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                 string result = arrParam[2].Value.ToString();
                 if (result == "0")
                 {
                     return ds.Tables[0];
                 }
                 else
                 {
                     throw new Exception(result);
                 }

             }

             catch (Exception ex)
             {
                 Exepciones.Log.LogToDB(ex.ToString());
                 throw ex;
             }
         }


        //Para el metodo de ConsultaJCE, WEB SERVICE
         public static DataTable getCiudadanosTSS_JCE(string nodocumento, string ult_usuario_act)
         {

             OracleParameter[] arrParam = new OracleParameter[4];
             arrParam[0] = new OracleParameter("p_no_documento", OracleDbType.NVarchar2, 11);
             arrParam[0].Value = nodocumento;
             arrParam[1] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 35);
             arrParam[1].Value = ult_usuario_act;
             arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[2].Direction = ParameterDirection.Output;
             arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[3].Direction = ParameterDirection.Output;

             string cmdStri = "srp_jce_pkg.getciudadanostss_jce";
             string[] result;

             try
             {
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);

                 result = arrParam[3].Value.ToString().Split(new char[] { '|' });
                 if (result[0] == "0")
                 {
                     return ds.Tables[0];
                 }
                 else if(result[0] == "-1")
                 {
                     throw new Exception(arrParam[3].Value.ToString());
                 }
                 else
                 {
                     throw new Exception(result[0]);
                 }
             }

             catch (Exception ex)
             {
                  Exepciones.Log.LogToDB(ex.ToString());
                  throw ex;
               
             }

         }



         public static string getNombreEmpleado(string Rnc, string Documento) {
             
             OracleParameter[] arrParam = new OracleParameter[3];
             arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
             arrParam[0].Value = Rnc;
             arrParam[1] = new OracleParameter("p_nro_documento", OracleDbType.NVarchar2 ,25);
             arrParam[1].Value = Documento;
             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[2].Direction = ParameterDirection.Output;


             string cmdStri = "ofc_oficios_pkg.buscaNroDoc";

             try
             {
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                 
                 string[] result = new string[2];
			     result = arrParam[2].Value.ToString().Split(new char[] {'|'});
                            
                 if (result[0] == "0")
                 {
                     return arrParam[2].Value.ToString();
                 }
                 else
                 {
                     return arrParam[2].Value.ToString();
                 }

             }

             catch (Exception ex)
             {
                 Exepciones.Log.LogToDB(ex.ToString());
                 throw ex;
             }
         
         }

         //Busca el nombre de un trabajador existente en esta empresa segun los parametros especificados
         // --p_Tipo_NSS_Ced : N = nss, C = cedula
         // --p_IdTrabajador : idNSS o NroDocumento
         public static string getTrabajadorByRNC(Int32 id_registro_patronal, string documento, string tipoNSSCedula)
         {
             OracleParameter[] arrParam;
             String cmdStr = "arl_pkg.gettrabajadorbyrnc";

             DataTable dt = new DataTable();

             //Definimos nuestro arreglo de parametros.
             arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_idregistro_patronal", OracleDbType.Int32);
             arrParam[0].Value = id_registro_patronal;

             arrParam[1] = new OracleParameter("p_idtrabajador", OracleDbType.Varchar2);
             arrParam[1].Value = documento;

             arrParam[2] = new OracleParameter("p_tipo_nss_ced", OracleDbType.Varchar2);
             arrParam[2].Value = tipoNSSCedula;

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

         //getCuestionario:trae un listado de preguntas previamente formuladas para la validacion y 
         //posterior recuperacion de class de un representante
         public static DataTable getCuestionario(Int32 id_registro_patronal,int Idnss)
         {

             OracleParameter[] arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_idregpatronal", OracleDbType.Int32);
             arrParam[0].Value = id_registro_patronal;
             arrParam[1] = new OracleParameter("p_IdNSS", OracleDbType.Int32);
             arrParam[1].Value = Idnss;
             arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[2].Direction = ParameterDirection.Output;
             arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[3].Direction = ParameterDirection.Output;

             String cmdStr = "sre_representantes_pkg.getcuestionario";

             try
             {
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                 string result = arrParam[3].Value.ToString();
                 if (result == "0")
                 {
                     return ds.Tables[0];
                 }
                 else
                 {
                     throw new Exception(result);
                 }

             }

             catch (Exception ex)
             {
                 Exepciones.Log.LogToDB(ex.ToString());
                 throw ex;
             }

         }

  //getRespuestaCuestionario:verifica la respuesta proporcionada por el representante a partir del id de una pregunta y 
  //se compara contra la base de datos dinamicamente utilizando un query previamente registrado para el id en curso en la tabla sre_custrionario_t
  //by charlie pena
 
        public static string getRespuestaCuestionario(Int32 id_registro_patronal,int Idnss, int idPregunta, string respuestaRepresentante)
         {
             OracleParameter[] arrParam;
             String cmdStr = "sre_representantes_pkg.getrespuestacuestionario";

             DataTable dt = new DataTable();

             //Definimos nuestro arreglo de parametros.
             arrParam = new OracleParameter[5];

             arrParam[0] = new OracleParameter("p_idregpatronal", OracleDbType.Int32);
             arrParam[0].Value = id_registro_patronal;

             arrParam[1] = new OracleParameter("p_IdNSS", OracleDbType.Int32);
             arrParam[1].Value = Idnss;

             arrParam[2] = new OracleParameter("p_idpregunta", OracleDbType.Varchar2);
             arrParam[2].Value = idPregunta;

             arrParam[3] = new OracleParameter("p_respuesta", OracleDbType.Varchar2);
             arrParam[3].Value = respuestaRepresentante;

             arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[4].Direction = ParameterDirection.Output;

             string result = string.Empty;
             try
             {

                 DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                 result = arrParam[4].Value.ToString();

                 return result;
             }
             catch (Exception ex)
             {
                 Exepciones.Log.LogToDB(ex.ToString());
                 throw ex;
             }
         }

        public static String IsSectorEconomico(int IdSectorEconomico)
		{
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_Id", OracleDbType.Int32,2);
			arrParam[0].Value = IdSectorEconomico;
			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,200);
			arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.issectoreconomico";
				
			DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

			try
            {
			  return arrParam[1].Value.ToString();
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}
        public static String IsSectorSalarial(int IdSectorSalarial)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Id", OracleDbType.Int32, 4);
            arrParam[0].Value = IdSectorSalarial;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.issectorsalarial";

            DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

            try
            {
                return arrParam[1].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public static String IsZonaFranca(string IdZonaFranca)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Id", OracleDbType.Varchar2, 5);
            arrParam[0].Value = IdZonaFranca;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.iszonafranca";

            DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

            try
            {
                return arrParam[1].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public static String IsMunicipio(string IdMunicipio)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Id", OracleDbType.Varchar2, 6);
            arrParam[0].Value = IdMunicipio;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.ismunicipio";

            DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

            try
            {
                return arrParam[1].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static String getPeriodoVigente(string FechaPeriodo)
		{
			OracleParameter[] arrParam  = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_FechaPeriodo", OracleDbType.Date);
            if (FechaPeriodo != null)
            {
                arrParam[0].Value = Convert.ToDateTime(FechaPeriodo);
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }
			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,200);
			arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_ARCHIVOS_PKG.getPeriodoVigente"; 
				
			DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

			try
            {
			  return arrParam[1].Value.ToString();
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

        public static String getPeriodoBonificacionValido(string Periodo)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Periodo", OracleDbType.NVarchar2, 6);
            arrParam[0].Value = Periodo;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_ARCHIVOS_PKG.getPeriodoBonificacion";

            DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

            try
            {   //devuelve true/false
                return arrParam[1].Value.ToString().ToUpper();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        //para complementar datos del ciudadano(retorna descripcion de municipio,tipo sangre,nacionalidad,causa inhabilidad)
        public static DataTable getComplementoCiudadano(string idMunicipio, string idSangre, string idNacionalidad, string idCausaInhabilidad, string tipoCausa)
        {

            OracleParameter[] arrParam = new OracleParameter[7];
            arrParam[0] = new OracleParameter("p_idMunicipio", OracleDbType.Varchar2);
            arrParam[0].Value = idMunicipio;
            arrParam[1] = new OracleParameter("p_idSangre", OracleDbType.Varchar2);
            arrParam[1].Value = idSangre;
            arrParam[2] = new OracleParameter("p_idNacionalidad", OracleDbType.Varchar2);
            arrParam[2].Value = idNacionalidad;
            arrParam[3] = new OracleParameter("p_idCausaInhabilidad", OracleDbType.Varchar2);
            arrParam[3].Value = idCausaInhabilidad;
            arrParam[4] = new OracleParameter("p_tipoCausa", OracleDbType.Varchar2);
            arrParam[4].Value = tipoCausa; 
            arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            string cmdStri = "Sre_Ciudadano_Pkg.getComplementoCiudadano";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                string result = arrParam[6].Value.ToString();
                if (result == "0")
                {
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }
                    else
                    {
                        return new DataTable();
                    }
                }
                else
                {
                    throw new Exception(result);
                }
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

   

    }
}
