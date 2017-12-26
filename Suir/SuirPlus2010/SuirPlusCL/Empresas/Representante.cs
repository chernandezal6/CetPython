using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas
{
	/// <summary>
	/// 
	/// </summary>
	public class Representante: Seguridad.Usuario 
	{
		//Atributos de un Empleador
		private int myRegistroPatronal, myIdNss;

		private Boolean myCompletoEncuesta;
		public Boolean CompletoEncuesta
		{
			set {this.myCompletoEncuesta = value;}
			get{return this.myCompletoEncuesta;}
		}

		private string myTipoRep, myFacturaXEmail,myTelefono1,myExt1,
					   myTelefono2, myExt2, myCedula, myRnc,myActualizarEmail;

		private Empleador myEmpleador;

		public Representante(string rnc, string cedula):base(rnc + cedula)
		{
			
			this.myIDTipoUsuario = "2";
			this.myCedula = cedula;
			this.myRnc = rnc;
			this.cargarDatosRepresentante();	

			this.myEmpleador = new Empleador(this.RegistroPatronal);

		}

		#region "  Metodos del Objeto  "

		private void cargarDatosRepresentante()
		{
			DataTable dt;
			dt = Representante.getRepresentante(this.RNC,this.Cedula);

			try
			{
				this.TipoRep = dt.Rows[0]["tipo_representante"].ToString();
				this.FacturaXEmail = dt.Rows[0]["factura_x_email"].ToString();
				this.Telefono1 = dt.Rows[0]["telefono_1"].ToString();
				this.Ext1 = dt.Rows[0]["ext_1"].ToString();
				this.Telefono2 = dt.Rows[0]["telefono_2"].ToString();
				this.Ext2 = dt.Rows[0]["ext_2"].ToString();
				this.Email = dt.Rows[0]["email"].ToString();
				this.myIdNss = int.Parse(dt.Rows[0]["id_nss"].ToString());
				this.myRegistroPatronal = int.Parse(dt.Rows[0]["id_registro_patronal"].ToString());
				this.myCedula = dt.Rows[0]["NO_DOCUMENTO"].ToString();
                this.myActualizarEmail = dt.Rows[0]["ACTUALIZAR_EMAIL"].ToString();

				if (dt.Rows[0]["completo_encuesta"].ToString() == "N")
				{this.myCompletoEncuesta = false;}
				else{this.myCompletoEncuesta = true;}

				dt.Dispose();

			}
			catch(Exception ex)
			{
				Exepciones.DataNoFoundException tmpException = new Exepciones.DataNoFoundException();
				tmpException.setMessage(ex.ToString());
				throw tmpException;
			}

		}

		public string quitarTodoAccesoNomina(string usuario)
		{
			return quitarTodoAccesoNomina(this.RegistroPatronal,this.IdNSS,usuario);
		}

		public bool tieneAcceso(Int32 idNomina)
		{
			return this.tieneAcceso(this.getAccesos(),idNomina);
		}

		public bool tieneAcceso(DataTable accesos, Int32 idNomina)
		{

			if (accesos.Rows.Count == 0) return false;

			foreach (DataRow dr in accesos.Rows)
			{
				if(Int32.Parse(dr.ItemArray[0].ToString()) == idNomina) return true;
			}

			return false;

		}

		public override String GuardarCambios(string UsuarioResponsable)
		{

			OracleParameter[] orParam = new OracleParameter[11];

			orParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal,10);
			orParam[0].Value = this.IdNSS;
			orParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal,9);
			orParam[1].Value = this.RegistroPatronal;
			orParam[2] = new OracleParameter("p_tipo_representante", OracleDbType.NVarchar2,1);
			orParam[2].Value = this.TipoRep; 
			orParam[3] = new OracleParameter("p_factura_x_email", OracleDbType.NVarchar2,1);
			orParam[3].Value = this.FacturaXEmail;
			orParam[4] = new OracleParameter("p_telefono_1", OracleDbType.NVarchar2,10);
			orParam[4].Value = this.Telefono1;
			orParam[5] = new OracleParameter("p_ext_1", OracleDbType.NVarchar2,4);
			orParam[5].Value = this.Ext1;
			orParam[6] = new OracleParameter("p_telefono_2", OracleDbType.NVarchar2,10);
			orParam[6].Value = this.Telefono2;
			orParam[7] = new OracleParameter("p_ext_2", OracleDbType.NVarchar2,4);
			orParam[7].Value = this.Ext2;  
			orParam[8] = new OracleParameter("p_email", OracleDbType.NVarchar2,50);
			orParam[8].Value = this.Email;
			orParam[9] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2,35);
			orParam[9].Value = UsuarioResponsable;
			orParam[10] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			orParam[10].Direction = ParameterDirection.InputOutput;

			try
			{
				SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"sre_representantes_pkg.representantes_editar",orParam);	
				return orParam[10].Value.ToString();
			}

			catch(Exception ex)
			{
                return ex.ToString();
			}
		}

		public string darAccesoNomina(int idNomina,
									  string usuario)
		{
			return Representante.darAccesoNomina(this.RegistroPatronal,idNomina,this.IdNSS,usuario);
		}

		public string quitarAccesoNomina(int idNomina,
										 string usuario)
		{
			return Representante.quitarAccesoNomina(this.RegistroPatronal,idNomina,this.IdNSS,usuario);
		}

		public DataTable getAccesos()
		{

			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
			arrParam[0].Direction = ParameterDirection.InputOutput;
			arrParam[0].Value = this.IdNSS;
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Direction = ParameterDirection.InputOutput;
			arrParam[1].Value = this.RegistroPatronal;
			arrParam[2] = new OracleParameter("p_id_rnc", OracleDbType.NVarchar2,11);
			arrParam[2].Value = DBNull.Value;
			arrParam[3] = new OracleParameter("p_numero_cedula", OracleDbType.NVarchar2,25);
			arrParam[3].Value = DBNull.Value;
			arrParam[4] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[4].Direction = ParameterDirection.Output;
			
			String cmdStr= "sre_representantes_pkg.accesos_nominas_select";

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

		#region "  Propiedades del Representante  "

		public Empleador Empleador
		{
			get
			{
				return this.myEmpleador;
			}
		}
		
			public int RegistroPatronal
			{
				get
				{
					return this.myRegistroPatronal;
				}
			}

			public int IdNSS
			{
				get
				{
					return this.myIdNss;
				}
			}

			public string TipoRep
			{
				get
				{
					return this.myTipoRep;
				}
				set
				{
					this.myTipoRep = value;
				}
			}

			public string FacturaXEmail
			{
				get
				{
					return this.myFacturaXEmail;
				}
				set
				{
					this.myFacturaXEmail = value;
				}
			}
			
			public string Telefono1
			{
				get
				{
					return this.myTelefono1;
				}
				set
				{
					this.myTelefono1 = value;
				}
			}

			public string Ext1
			{
				get
				{
					return this.myExt1;
				}
				set
				{
					this.myExt1 = value;
				}
			}

			public string Telefono2
			{
				get
				{
					return this.myTelefono2;
				}
				set
				{
					this.myTelefono2 = value;
				}
			}

			public string Ext2
			{
				get
				{
					return this.myExt2;
				}
				set
				{
					this.myExt2 = value;
				}
			}

			public string Cedula
			{
				get
				{
					return this.myCedula;
				}
		
			}

			public string RNC
			{
				get
				{
					return this.myRnc;
				}
			}

            public string ActualizarEmail
			{
				get
				{
                    return this.myActualizarEmail;
				}
				set
				{
                    this.myActualizarEmail = value;
				}
			}
        


		#endregion

		#region "  Funciones Estaticas de Validacion, Busqueda y Actualizaciones "


		public static DataTable getRepresentante(string rnc, string cedula)
		{
			return getRepresentante(-1,-1,rnc,cedula);
		}

		public static DataTable getRepresentante(int idNss, int idRegistroPatronal)
		{
			return getRepresentante(idNss,idRegistroPatronal,"","");
		}

		public static DataTable getRepresentante(int idNss, int idRegistroPatronal, string rnc, string cedula)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);			
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(idNss);
			
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);			
			arrParam[1].Value = Utilitarios.Utils.verificarNulo(idRegistroPatronal);
			
			arrParam[2] = new OracleParameter("p_id_rnc", OracleDbType.Varchar2,11);
			arrParam[2].Value = Utilitarios.Utils.verificarNulo(rnc);
			
			arrParam[3] = new OracleParameter("p_numero_cedula", OracleDbType.Varchar2,25);
			arrParam[3].Value = Utilitarios.Utils.verificarNulo(cedula);

			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 500);
			arrParam[4].Direction = ParameterDirection.Output;
			
			arrParam[5] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[5].Direction = ParameterDirection.Output;
			
			String cmdStr= "sre_representantes_pkg.representantes_select";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}


		}

		public static DataTable getNominasRep(int idNss, int idRegistroPatronal)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
			arrParam[0].Direction = ParameterDirection.InputOutput;
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(idNss);
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Direction = ParameterDirection.InputOutput;
			arrParam[1].Value = Utilitarios.Utils.verificarNulo(idRegistroPatronal);
			arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
			
			String cmdStr= "sre_representantes_pkg.get_AccesosNominaTrabajador";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		public static DataTable getNominasRepDependientes(int idNss, int idRegistroPatronal)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
			arrParam[0].Direction = ParameterDirection.InputOutput;
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(idNss);
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Direction = ParameterDirection.InputOutput;
			arrParam[1].Value = Utilitarios.Utils.verificarNulo(idRegistroPatronal);
			arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
			
			String cmdStr= "sre_representantes_pkg.get_AccesosNominaDependientes";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		public static DataTable getTrabCedulaCancelada(int idNss, int idRegistroPatronal)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
			arrParam[0].Direction = ParameterDirection.InputOutput;
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(idNss);
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Direction = ParameterDirection.InputOutput;
			arrParam[1].Value = Utilitarios.Utils.verificarNulo(idRegistroPatronal);
			arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
			
			String cmdStr= "sre_representantes_pkg.get_Trabajador_Ced_Cancelada";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}


		}

        public static string insertaRepresentante(string NoDocumento,
												int idRegistroPatronal,
												String tipoRepresentante,
												String facturaXEmail, 
												String telefono1, 
												String ext1,
												String telefono2,
												String ext2, 
												String email,
                                                String usuario)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[11];

            arrParam[0] = new OracleParameter("p_NoDocumento", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = NoDocumento;
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Value = idRegistroPatronal;
			arrParam[2] = new OracleParameter("p_tipo_representante", OracleDbType.NVarchar2, 1);
			arrParam[2].Value = tipoRepresentante;
			arrParam[3] = new OracleParameter("p_factura_x_email", OracleDbType.NVarchar2, 1);
			arrParam[3].Value = facturaXEmail;
			arrParam[4] = new OracleParameter("p_telefono_1", OracleDbType.NVarchar2, 10);
			arrParam[4].Value = telefono1;
			arrParam[5] = new OracleParameter("p_ext_1", OracleDbType.NVarchar2, 4);
			arrParam[5].Value = ext1;
			arrParam[6] = new OracleParameter("p_telefono_2", OracleDbType.NVarchar2, 10);
			arrParam[6].Value = telefono2;
			arrParam[7] = new OracleParameter("p_ext_2", OracleDbType.NVarchar2, 4);
			arrParam[7].Value = ext2;
			arrParam[8] = new OracleParameter("p_email", OracleDbType.NVarchar2, 50);
			arrParam[8].Value = email;
			arrParam[9] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[9].Value = usuario;
			arrParam[10] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[10].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_representantes_pkg.representantes_crear";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[10].Value.ToString();			
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		
		public static string quitarTodoAccesoNomina(int idRegistroPatronal,
			int idNss, string usuario)
		{

			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[0].Value = idRegistroPatronal;
			arrParam[1] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
			arrParam[1].Value = idNss;
            arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[2].Value = usuario;
			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_representantes_pkg.quitar_todo_acceso_nomina";

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




		public static string darAccesoNomina(int idRegistroPatronal,
											 int idNomina,
											 int idNss,
											 string usuario)
		{

			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[0].Value = idRegistroPatronal;
			arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
			arrParam[1].Value = idNomina;
			arrParam[2] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
			arrParam[2].Value = idNss;
			arrParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[3].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(usuario);
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_representantes_pkg.dar_acceso_nomina";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[4].Value.ToString();			
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}

		public static string borraRepresentante(int idRegistroPatronal,
			int idNss, String usuario )
		{

			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
			arrParam[0].Value = idNss;
			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Value = idRegistroPatronal;
			arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[2].Value = usuario;
			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_representantes_pkg.representantes_desactivar";

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

		public static string quitarAccesoNomina(int idRegistroPatronal,
												int idNomina,
												int idNss,
                                                string usuario)
		{
		
			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[0].Value = idRegistroPatronal;
			arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal, 10);
			arrParam[1].Value = idNomina;
			arrParam[2] = new OracleParameter("p_id_nss", OracleDbType.Decimal);
			arrParam[2].Value = idNss;
            arrParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[3].Value = usuario;                
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_representantes_pkg.quitar_acceso_nomina";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[4].Value.ToString();			
			}
			catch(Exception ex)
			{
				throw ex;
			}
	
		}
		
		/// <summary>
		/// Función utilizada para verificar si un usuario es representante de un registro patronal y de la nomina que quiere consultar.
		/// </summary>
		/// <param name="mensaje">Un parametro por referencia que tendrá valor unicamente si la funcion retorna false.</param>
		/// <param name="idRegistroPatronal">Registro patronal de la empresa que se quiere verificar el representante.</param>
		/// <param name="idNomina">Id de la nomina que quiere consultar el representante.</param>
		/// <param name="usuarioRepresentante">El usuario del representante.</param>
		/// <remarks>Creado por Ronny J. Carreras</remarks>
		/// <returns></returns>
		public static bool isRepresentanteParaNomina(ref string mensaje, int idRegistroPatronal, int idNomina,  string usuarioRepresentante)
		{	
				
			string resultado;
			OracleParameter[] arrParam = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
			arrParam[0].Value = idNomina;

			arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			arrParam[1].Value = idRegistroPatronal;

			arrParam[2] = new OracleParameter("p_usuariorep", OracleDbType.NVarchar2, 35);
			arrParam[2].Value = usuarioRepresentante;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			arrParam[3].Direction = ParameterDirection.Output;

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sre_representantes_pkg.get_AccesosNomina",arrParam);
				resultado = arrParam[3].Value.ToString();
				resultado = Utilitarios.Utils.sacarMensajeDeError(resultado);
			}

			catch(Exception ex)
			{
				throw ex;
			}
				
			if(resultado.Equals("OK"))
			{
				mensaje = string.Empty;
				return true;
			}
			else
			{
				mensaje = resultado;
				return false;
			}

		}


        public static DataTable getRepresentanteLista(int idRegistroPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(idRegistroPatronal);

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_representantes_pkg.Get_RepresentantesLista";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }

        public static String ActivarRepresentante(string UsuarioResponsable,string Nss, int RegistroPatronal,string status)
        {

            OracleParameter[] orParam = new OracleParameter[5];

            orParam[0] = new OracleParameter("p_id_nss", OracleDbType.Decimal, 10);
            orParam[0].Value = Nss;
            orParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal, 9);
            orParam[1].Value = RegistroPatronal;
            orParam[2] = new OracleParameter("p_status", OracleDbType.NVarchar2, 1);
            orParam[2].Value = status;
            orParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            orParam[3].Value = UsuarioResponsable;
            orParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[4].Direction = ParameterDirection.InputOutput;

            try
            {
                SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sre_representantes_pkg.representantes_activar", orParam);
                return orParam[4].Value.ToString();
            }

            catch (Exception ex)
            {
                return ex.ToString();
            }
        }

        public static string ActualizarEmailRepresentante(string usuario, string email, string link_params, string accion)
		{
			OracleParameter[] arrParam  = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.Varchar2, 300);
			arrParam[0].Value = usuario;
			arrParam[1] = new OracleParameter("p_email", OracleDbType.Varchar2, 300);
			arrParam[1].Value = email;
            arrParam[2] = new OracleParameter("p_link_params", OracleDbType.Varchar2, 4000);
            arrParam[2].Value = link_params;
			arrParam[3] = new OracleParameter("p_accion", OracleDbType.Varchar2, 1);
			arrParam[3].Value = accion;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;
				
			String cmdStr= "sre_representantes_pkg.actemailrepresentante";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[4].Value.ToString();			
			}
			catch(Exception ex)
			{
                return ex.ToString();
			}

		}

        //---------------------eu

        public static DataTable getEmpresasRepresentate(string cedula)
        {
            DataTable DtEmpresasRepresentante;
            
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = cedula;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sre_representantes_pkg.getempresasrepresentate";
            string res = string.Empty;
           
            
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                res = arrParam[2].Value.ToString();
                
                
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }
                

                return new DataTable(res);
                              
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                return null;
            }

            return DtEmpresasRepresentante;
        }
        
        //Para fines de deshabilitar un representante temporalmente.

        public static string deshabilitar_rep(int Nss, int RegistroPatronal, string status,string usuario)
        {

            OracleParameter[] orParam = new OracleParameter[5];

            orParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            orParam[0].Value = Nss;
            orParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            orParam[1].Value = RegistroPatronal;
            orParam[2] = new OracleParameter("p_status", OracleDbType.Varchar2);
            orParam[2].Value = status;
            orParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 35);
            orParam[3].Value = usuario;
            orParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 500);
            orParam[4].Direction = ParameterDirection.InputOutput;

            String cmdStr = " sre_representantes_pkg.deshabilitar_rep";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, orParam);
                return orParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getRepresentanteListaActivos(int idRegistroPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(idRegistroPatronal);

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_representantes_pkg.get_listarepresentantesactivos";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }


        //public static string RecuperarClassRep(string usuario, string email, string accion)
        //{
        //    OracleParameter[] arrParam = new OracleParameter[4];

        //    arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.Varchar2, 300);
        //    arrParam[0].Value = usuario;
        //    arrParam[1] = new OracleParameter("p_email", OracleDbType.Varchar2, 300);
        //    arrParam[1].Value = email;
        //    arrParam[2] = new OracleParameter("p_accion", OracleDbType.Varchar2, 1);
        //    arrParam[2].Value = accion;
        //    arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
        //    arrParam[3].Direction = ParameterDirection.Output;

        //    String cmdStr = "sre_representantes_pkg.recuperarclassrep";

        //    try
        //    {
        //        DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
        //        return arrParam[3].Value.ToString();
        //    }
        //    catch (Exception ex)
        //    {
        //        return ex.ToString();
        //    }

        //}
		#endregion


	}
}
