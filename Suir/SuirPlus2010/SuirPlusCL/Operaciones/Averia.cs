using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Operaciones
{
	/// <summary>
	/// Summary description for Averia.
	/// </summary>
	public class Averia : FrameWork.Objetos 
	{
		private int myIdAveria, myTipoAveria;
		private string myDescTipoAveria, myDescStatus, myEmail;
		private string  myProblemaDes, myAvanceDes, myReportadoPor,  myRegistradoPor, myRegistradoVia,  myCerradoPor, myCerradoDes, myStatus,  myCerradoEn;
		private DateTime myReportadoEn,myRegistradoEn;


		public Averia(int IdAveria)
		{
			this.myIdAveria = IdAveria;
			this.CargarDatos();
		}

		#region "  Propiedades de Averia  "

		
		public int IdAveria
		{
			get
			{
				return this.myIdAveria;
			}
		}

		public int TipoAveria
		{
			get
			{
				return this.myTipoAveria;
			}
			set
			{
				this.myTipoAveria = value;
			}
		}
		public string DescTipoAveria
		{
			get {return this.myDescTipoAveria;}
		}

		public string ProblemaDes
		{
			get
			{
				return this.myProblemaDes; 
			}
			set
			{
				this.myProblemaDes = value;
			}
		}

		public string AvanceDes
		{
			get
			{
				return this.myAvanceDes; 
			}
			set 
			{
				this.myAvanceDes= value; 
			}
		}

		public string ReportadoPor
		{
			get
			{
				return this.myReportadoPor; 
			}
			set
			{
				this.myReportadoPor = value; 
			}
		}
		public string Email
		{
			get
			{
				return this.myEmail; 
			}
			set
			{
				this.myEmail = value; 
			}
		}
		public DateTime ReportadoEn
		{
			get
			{
				return this.myReportadoEn; 
			}
			
		}

		public string RegistradoPor
		{
			get
			{
				return this.myRegistradoPor; 
			}
			set
			{
				this.myRegistradoPor = value; 
			}
		}
		public string RegistradoVia
		{
			get
			{
				return this.myRegistradoVia; 
			}
			set
			{
				this.myRegistradoVia = value; 
			}
		}
		public DateTime RegistradoEn
		{
			get
			{
				return this.myRegistradoEn; 
			}
			
		}
		public string CerradoPor
		{
			get
			{
				return this.myCerradoPor; 
			}
			set
			{
				this.myCerradoPor = value; 
			}
		}
		public string CerradoEn
		{
			get
			{
				return this.myCerradoEn; 
			}
			
		}
		public string CerradoDes
		{
			get
			{
				return this.myCerradoDes; 
			}
			set
			{
				this.myCerradoDes = value; 
			}
		}
		public string Status
		{
			get
			{
				return this.myStatus; 
			}
			set
			{
				this.myStatus = value; 
			}
		}
		public string DescStatus
		{
			get {return this.myDescStatus;}
		}
			#endregion

		#region "  Metodos sobrecargados  "

		public override void CargarDatos()
		{

			

//			try
//			{
				DataTable dt;
				dt = Averia.getAveria(this.myIdAveria);
				DataRow tmpDr = dt.Rows[0];
				this.myIdAveria   = Convert.ToInt32(dt.Rows[0]["id_averia"].ToString());
				//this.myTipoAveria  = Convert.ToInt32(dt.Rows[0]["id_tipo_averia"].ToString());
				this.myTipoAveria  = Convert.ToInt32(dt.Rows[0]["id_tipo_averia"].ToString());
				this.ProblemaDes  = dt.Rows[0]["problema_des"].ToString();
				this.AvanceDes = dt.Rows[0]["avance_des"].ToString();
				this.ReportadoPor  = dt.Rows[0]["reportado_por"].ToString();
				this.Email = dt.Rows[0]["email"].ToString();  
				if(! (tmpDr["reportado_en"] is DBNull)) this.myReportadoEn = (DateTime)tmpDr["reportado_en"];
				this.RegistradoPor   = dt.Rows[0]["registrado_por"].ToString();
				this.RegistradoVia   = dt.Rows[0]["registrado_via"].ToString();
				if(! (tmpDr["registrado_en"] is DBNull)) this.myRegistradoEn = (DateTime)tmpDr["registrado_en"];
				this.CerradoPor    = dt.Rows[0]["cerrado_por"].ToString();
				this.myCerradoEn = dt.Rows[0]["cerrado_en"].ToString();
				this.CerradoDes    = dt.Rows[0]["cerrado_des"].ToString();
				this.Status     = dt.Rows[0]["status"].ToString();
				this.myDescStatus = dt.Rows[0]["Status_desc"].ToString();
				this.myDescTipoAveria = dt.Rows[0]["tipo_averia_des"].ToString();

				dt.Dispose();

//			}
//			catch(Exception ex)
//			{
//				Exepciones.DataNoFoundException tmpException = new Exepciones.DataNoFoundException();
//				tmpException.setMessage(ex.ToString());
//				throw tmpException;
//			}
 
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{

			OracleParameter[] orParam = new OracleParameter[5];

			orParam[0] = new OracleParameter("p_id_averia", OracleDbType.Decimal);
			orParam[0].Value = this.myIdAveria; 
			orParam[1] = new OracleParameter("p_Tipo", OracleDbType.Decimal);
			orParam[1].Value = this.myTipoAveria; 
			orParam[2] = new OracleParameter("p_avance_des", OracleDbType.NVarchar2);
			orParam[2].Value = this.myAvanceDes;
			orParam[3] = new OracleParameter("p_usuarioModifica", OracleDbType.NVarchar2);
			orParam[3].Value = UsuarioResponsable;
			orParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			orParam[4].Direction = ParameterDirection.Output;


			try
			{
				SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"ave_Averias_pkg.Actualizar_RegistroAveria",orParam);	
				return orParam[4].Value.ToString();
			}

			catch(Exception ex)
			{
				return ex.ToString();
			}
		}


		#endregion

		#region "  Funciones Estaticas "
        
		public static string insertaAverias(int TipoAveria,
			String problemades, 
			String reportadopor,
			String Email,
			String registradopor,
			String registradovia
			)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[7];

			arrParam[0] = new OracleParameter("p_id_tipo_averia", OracleDbType.Decimal);
			arrParam[0].Value = TipoAveria;
			arrParam[1] = new OracleParameter("p_problema_des", OracleDbType.NVarchar2, 4000);
			arrParam[1].Value = problemades;
			arrParam[2] = new OracleParameter("p_reportado_por", OracleDbType.NVarchar2, 100);
			arrParam[2].Value = reportadopor;
			arrParam[3] = new OracleParameter("p_email", OracleDbType.NVarchar2, 75);
			arrParam[3].Value = Email;
			arrParam[4] = new OracleParameter("p_registrado_por", OracleDbType.NVarchar2, 100);
			arrParam[4].Value = registradopor;
			arrParam[5] = new OracleParameter("p_registrado_via", OracleDbType.NVarchar2, 100);
			arrParam[5].Value = registradovia;
			arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[6].Direction = ParameterDirection.Output;
				
			String cmdStr= "ave_Averias_pkg.Crear_RegistroAveria";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[6].Value.ToString();			
			}
			catch(Exception ex)
			{
				throw ex;
			}


		}
		

		public static DataTable getAveria(int IdAveria)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_IdAveria", OracleDbType.Decimal);
			arrParam[0].Value = IdAveria;
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

				
			String cmdStr= "ave_Averias_pkg.RegistroAverias_PorIdAveria";


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
		public static DataTable getAveriaPorTipoAveria(int TipoAveria)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_TipoAveria", OracleDbType.Decimal);
			arrParam[0].Value = TipoAveria;
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;
				
			String cmdStr= "ave_Averias_pkg.RegistroAverias_PorTipo";


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
		public static DataTable getAveriasPorStatus(string status)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_status", OracleDbType.Char, 1);
			arrParam[0].Value = status;
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;
				
			String cmdStr= "ave_Averias_pkg.RegistroAverias_Status";

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
			public static DataTable getAveriasPorUsuarioReporto(string UsuarioReporto)
			{
			
				OracleParameter[] arrParam  = new OracleParameter[3];

				arrParam[0] = new OracleParameter("p_IdUsuarioRep", OracleDbType.NVarchar2, 100);
				arrParam[0].Value = UsuarioReporto;
				arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
				arrParam[1].Direction = ParameterDirection.Output;
				arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
				arrParam[2].Direction = ParameterDirection.Output;
				
				String cmdStr= "ave_Averias_pkg.RegistroAverias_Reportada";

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
		public static DataTable getAveriasPorUsuarioRegistro(string UsuarioRegistro)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_IdUsuarioReg", OracleDbType.NVarchar2, 100);
			arrParam[0].Value = UsuarioRegistro;
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;
				
			String cmdStr= "ave_Averias_pkg.RegistroAverias_Registradas";

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
		public static DataTable getTipoAverias()
		{
			

			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("IO_Cursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;
		
			String cmdStr= "ave_Averias_pkg.GET_TIPO_AVERIAS";

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
		public static DataTable getUsuarioReporto()
		{
			

			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("IO_Cursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;
		
			String cmdStr= "ave_Averias_pkg.Get_UsuarioReporta";

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
		public static DataTable getUsuarioRegistro()
		{
			

			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("IO_Cursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;
		
			String cmdStr= "ave_Averias_pkg.Get_UsuarioRegistra";

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


		public string CerrarCaso(String DescripcionSolucion, String usuario)
		{
			string cmdStr = "AVE_AVERIAS_PKG.Cierre_RegistroAveria";
			OracleParameter[] arrParam = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_averia", OracleDbType.Decimal);
			arrParam[0].Value = this.IdAveria;
			arrParam[1] = new OracleParameter("p_IdUsuario", OracleDbType.NVarchar2, 35);
			arrParam[1].Value = usuario;
			arrParam[2] = new OracleParameter("p_DescripcionCierre", OracleDbType.NVarchar2, 600);
			arrParam[2].Value = DescripcionSolucion;
			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[3].Value.ToString();
			}
			catch(Exception ex)
			{
				throw ex;
			}
			
		}
	}
}
