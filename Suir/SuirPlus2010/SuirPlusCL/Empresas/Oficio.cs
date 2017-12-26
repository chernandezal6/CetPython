using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas
{
	/// <summary>
	/// Summary description for Oficio.
	/// </summary>
	public class Oficio
	{
		
		// Atributos privados
		private int idOficio, idAccion, idMotivo, idRegistroPatronal, periodoFinProceso;
		
		private string usuarioSolicita ,nombreUsuarioSolicita, usuarioProcesa, nombreUsuarioProcesa, status, destinatario, 
			obsSolicita, obsProcesa, descStatus, textoAccion, textoMotivo, accionDes,
            rncCedula, razonSocial, departamento, id_solicitud, id_acuerdo, id_acuerdo_ordinario,cedula,nombre_completo;
		
		private DateTime fechaSolicita, fechaProcesa, fechaCancela;
		
		private DataTable detalle;
				
		public Oficio(int idOficio)
		{
			this.idOficio = idOficio;
			this.cargarDatos();
		}

		# region "  Propiedades publicas  "

		public string NombreUsuarioProcesa
		{
			get
			{
				return this.nombreUsuarioProcesa;
			}
		}
		
		public DataTable Detalle
		{
			get
			{
				return this.detalle;
			}
		}

		public string Departamento
		{
			get
			{
				return this.departamento;
			}
		}

		public string RncCedula
		{
			get
			{
				return this.rncCedula;
			}
		}
		
		public string RazonSocial
		{
			get
			{
				return this.razonSocial;
			}
		}

		public string TextoAccion
		{
			get
			{
				return this.textoAccion;
			}
		}
		
		public string TextoMotivo
		{
			get
			{
				return this.textoMotivo;
			}
		}

		public string AccionDes
		{
			get
			{
				return this.accionDes;
			}
		}

		public int IdOficio
		{
			get
			{
				return this.idOficio;
			}
		}

		public int IdAccion
		{
			get
			{
				return this.idAccion;
			}
		}

		public int IdMotivo
		{
			get
			{
				return this.idMotivo;
			}
		}

		public int IdRegistroPatronal
		{
			get
			{
				return this.idRegistroPatronal;
			}
		}

		public int PeriodoFinProceso
		{
			get
			{
				return this.periodoFinProceso;
			}
		}

		public string DescStatus
		{
			get
			{
				return this.descStatus;
			}
		}

		public string UsuarioSolicita
		{
			get
			{
				return this.usuarioSolicita;
			}
		}

		public string NombreUsuarioSolicita
		{
			get
			{
				return this.nombreUsuarioSolicita;
			}
		}

		public string UsuarioProcesa
		{
			get
			{
				return this.usuarioProcesa;
			}
		}

		public string Status
		{
			get
			{
				return this.status;
			}
		}

		public string Destinatario
		{
			get
			{
				return this.destinatario;
			}
		}

		public string ObsSolicita
		{
			get
			{
				return this.obsSolicita;
			}
		}

		public string ObsProcesa
		{
			get
			{
				return this.obsProcesa;
			}
		}

		public DateTime FechaSolicita
		{
			get
			{
				return this.fechaSolicita;
			}
		}

		public DateTime FechaProcesa
		{
			get
			{
				return this.fechaProcesa; 
			}
		}

        public DateTime FechaCancela
        {
            get
            {
                return this.fechaCancela;
            }
        }

        public string Cedula_Suspencion {
            get {
              return  this.cedula;
            }
        }
        public string NombreTrabajador {

            get {
                return this.nombre_completo;
            }
        }
        
		# endregion

		private void cargarDatos()
		{

			DataTable tmpDt  = Oficio.getOficio(this.idOficio);

			if(tmpDt.Rows.Count > 0)
			{
				
				DataRow tmpDr = tmpDt.Rows[0];

				this.idAccion = int.Parse(tmpDr["id_accion"].ToString());
				this.idMotivo = int.Parse(tmpDr["id_motivo"].ToString());
				this.idRegistroPatronal = int.Parse(tmpDr["id_registro_patronal"].ToString());
				this.destinatario = (string)tmpDr["destinatario"];
				this.departamento = (tmpDr["comentario"] is DBNull ? "" :(string)tmpDr["comentario"]);
				this.status = (string)tmpDr["status"];
				this.descStatus = (string)tmpDr["Status Desc"];
				this.usuarioSolicita = (string)tmpDr["usuario_solicita"];
				this.nombreUsuarioSolicita = (string)tmpDr["NOMBRE USUARIO SOLICITA"];
				this.usuarioProcesa = (tmpDr["usuario_procesa"] is DBNull?"":(string)tmpDr["usuario_procesa"]);
				this.obsProcesa = (tmpDr["observaciones_procesa"] is DBNull ? "" :(string)tmpDr["observaciones_procesa"]);
				this.obsSolicita = (tmpDr["observaciones_solicita"] is DBNull ? "" :(string)tmpDr["observaciones_solicita"]);
				this.periodoFinProceso = int.Parse(tmpDr["periodo_fin_proceso"].ToString());
				this.fechaSolicita = (DateTime)tmpDr["fecha_solicita"];
				if(! (tmpDr["fecha_procesa"] is DBNull)) this.fechaProcesa = (DateTime)tmpDr["fecha_procesa"];
                if (!(tmpDr["fecha_cancela"] is DBNull)) this.fechaCancela = (DateTime)tmpDr["fecha_cancela"];
				this.rncCedula = (string)tmpDr["rnc_o_cedula"];
				this.razonSocial = (string)tmpDr["razon_social"];
				this.textoMotivo = (string)tmpDr["texto_motivo"];
          


                if (this.idAccion == 4)
                    {
                        this.id_solicitud = (tmpDr["id_solicitud"].ToString() is DBNull ? "" :(string)tmpDr["id_solicitud"].ToString());
                    }

                if (this.idAccion == 5)
                    {
                        this.id_acuerdo = (tmpDr["id_acuerdo"].ToString() is DBNull ? "" : (string)tmpDr["id_acuerdo"].ToString());
                    }
                if (this.idAccion == 6)
                    {
                       id_acuerdo_ordinario  = (tmpDr["id_acuerdo"].ToString() is DBNull ? "" : (string)tmpDr["id_acuerdo"].ToString());
                    
                        if (id_acuerdo_ordinario != string.Empty)
                        {
                            if(tmpDr["tipo"].ToString() == "3"){
                                this.id_acuerdo = "AO-" + id_acuerdo_ordinario;
                            }
                            if (tmpDr["tipo"].ToString() == "4")
                            {
                                this.id_acuerdo = "AE-" + id_acuerdo_ordinario;
                            }
                            
                        }
                        else 
                        {
                            this.id_acuerdo = string.Empty; 
                        }
                    }

                if (this.idAccion == 9) {
                    this.cedula = (string)tmpDr["CEDULA"];
                    this.nombre_completo = (string)tmpDr["NOMBRE_COMPLETO"];
                }
				this.textoAccion = this.getTextoAccion((string)tmpDr["texto_accion"]);
				this.accionDes = (string)tmpDr["accion_des"];
				this.nombreUsuarioProcesa = (tmpDr["NOMBRE USUARIO PROCESA"] is DBNull ? "" :(string)tmpDr["NOMBRE USUARIO PROCESA"]);

                
                               

				//Cargando detalle
				this.detalle = Oficio.getDetOficio(this.idOficio);
			}
			else
			{
				throw new Exception("Este oficio no existe." + idOficio.ToString());
			}

		}

		private string getTextoAccion(string textoAccion)
		{
			string tmpStr = textoAccion.Replace("%RAZON_SOCIAL%", "<b>" + this.RazonSocial + "</b>");
			tmpStr = tmpStr.Replace("%RNC/CEDULA%", "<b>" + this.RncCedula + "</b>");
            tmpStr = tmpStr.Replace("%ID_SOLICITUD%", "<b>" + this.id_solicitud + "</b>");
            tmpStr = tmpStr.Replace("%ID_ACUERDO%", "<b>" + this.id_acuerdo + "</b>");
            tmpStr = tmpStr.Replace("%NOMBRE_COMPLETO%", "<b>" + this.NombreTrabajador + "</b>");
            tmpStr = tmpStr.Replace("%CEDULA%", "<b>" + this.Cedula_Suspencion + "</b>");
            tmpStr = tmpStr.Replace("%FECHA%", "<b>" + this.FechaSolicita.ToString("dd/MM/yyyy") + "</b>");
            tmpStr = tmpStr.Replace("%PERIODO_FECHA%", "<b>" + this.PeriodoFinProceso + "</b>");


			return tmpStr;
		}


		#region "  Funciones Estaticas de Validacion, Busqueda y Actualizaciones "

		public static DataTable getOficio(int idOficio)
		{

			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
			arrParam[0].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(idOficio);
				
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.InputOutput;

			String cmdStr= "OFC_OFICIOS_PKG.Get_Oficios";
 
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

        public static DataTable getOficio(string rncCedula, string fechaIni, string fechaFin,
                                  string idUsuario, int idOficio)
		{

			OracleParameter[] arrParam  = new OracleParameter[7];

			arrParam[0] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2,11);
			arrParam[0].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(rncCedula);

			arrParam[1] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2,35);
			arrParam[1].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(idUsuario);

            arrParam[2] = new OracleParameter("p_fechadesde", OracleDbType.Varchar2, 10);
			arrParam[2].Value =  fechaIni;

            arrParam[3] = new OracleParameter("p_fechahasta", OracleDbType.Varchar2, 10);
			arrParam[3].Value =  fechaFin;

            arrParam[4] = new OracleParameter("p_oficio", OracleDbType.Int32);
            arrParam[4].Value = idOficio;
            
            arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[5].Direction = ParameterDirection.Output;

			arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[6].Direction = ParameterDirection.InputOutput;

			String cmdStr= "OFC_OFICIOS_PKG.Get_Rango_Fechas";
            String Resultado = "";
 
			try
			{
				DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[6].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable();
                    Utilitarios.Utils.agregarMensajeError(Resultado, ref dt);
                    return dt;
                }

                return ds.Tables[0];

			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
                throw new Exception(Resultado);
			}


		}

		
		public static DataTable getDetOficio(int idOficio)
		{

			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
			arrParam[0].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(idOficio);
				
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.InputOutput;

			String cmdStr= "OFC_OFICIOS_PKG.Get_det_Oficios";
 
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
		public static DataTable getDetalleOficios(int idOficio)
		{

			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
			arrParam[0].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(idOficio);
				
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.InputOutput;

			String cmdStr= "OFC_OFICIOS_PKG.Detalle_Oficios";
 
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
		//  Facturas generadas por Id_Oficio.
        public static DataTable getFacturasGeneradasOficio(int idOficio)
        {


            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idOficio);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.InputOutput;

            String cmdStr = "OFC_OFICIOS_PKG.Detalle_Generado_por_Oficio";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }
		//  Facturas generadas por Mismo Período,Rnc, Nomina.
		public static DataTable getFacturasParametros(int idOficio)
		{

			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
			arrParam[0].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(idOficio);
				
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.InputOutput;

			String cmdStr= "OFC_OFICIOS_PKG.Detalle_Generado_por_PRN";
 
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

		//  Facturas generadas por factura desde Referencia Origen.
		public static DataTable getFacturasRefOrigen(int idOficio)
		{

			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
			arrParam[0].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(idOficio);
				
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.InputOutput;

			String cmdStr= "OFC_OFICIOS_PKG.Listado_Facturas";
 
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
		
		public static DataTable getAcciones(int idAccion)
			{

			
			    OracleParameter[] arrParam  = new OracleParameter[3];
            	arrParam[0] = new OracleParameter("p_idaccion", OracleDbType.Decimal);
				arrParam[0].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(idAccion);
				arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
				arrParam[1].Direction = ParameterDirection.Output;
            	arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
				arrParam[2].Direction = ParameterDirection.InputOutput;

				String cmdStr= "OFC_OFICIOS_PKG.Get_Acciones";
 
				try
				{
					DataSet ds =  DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
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
			
		public static DataTable getMotivos(int idAccion)
		{

			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_idaccion", OracleDbType.Decimal);
			arrParam[0].Value =  SuirPlus.Utilitarios.Utils.verificarNulo(idAccion);
		    arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.InputOutput;

			String cmdStr= "OFC_OFICIOS_PKG.Get_Motivos";
 
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

        public static DataTable getFacturas(string rncCedula)
        {


            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(rncCedula);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.InputOutput;

            String cmdStr = "OFC_OFICIOS_PKG.Get_Facturas";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                try
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
            }


        }

		
		public static string insertaOficio(int idAccion,
			int idMotivo,
			string rncCedula,
			string usuarioSolicita, 
			string destinatario,
			string obSolicita,
			int periodoFinProceso,string nro_documento,
            Int32 sectorSalarial,
            string fecha_proceso, string p_id_nomina,bool p_marca)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[13];

			arrParam[0] = new OracleParameter("p_id_accion", OracleDbType.Decimal);
			arrParam[0].Value = idAccion; 
			arrParam[1] = new OracleParameter("p_id_motivo", OracleDbType.Decimal);
			arrParam[1].Value = idMotivo;
			arrParam[2] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2,11);
			arrParam[2].Value = rncCedula;
			arrParam[3] = new OracleParameter("p_usuario_solicita", OracleDbType.NVarchar2, 35);
			arrParam[3].Value = usuarioSolicita;
			arrParam[4] = new OracleParameter("p_destinatario", OracleDbType.NVarchar2, 100);
			arrParam[4].Value = destinatario;
			arrParam[5] = new OracleParameter("p_observaciones_solicita", OracleDbType.NVarchar2, 1000);
			arrParam[5].Value = obSolicita;
			arrParam[6] = new OracleParameter("p_periodo_fin_proceso", OracleDbType.Decimal);
			arrParam[6].Value = periodoFinProceso;
            arrParam[7] = new OracleParameter("p_cod_sector", OracleDbType.Int32);
            arrParam[7].Value = sectorSalarial;
            arrParam[8] = new OracleParameter("p_nro_documento", OracleDbType.NVarchar2);
            arrParam[8].Value = nro_documento;
            arrParam[9] = new OracleParameter("p_id_nomina", OracleDbType.NVarchar2, 11);
            arrParam[9].Value = p_id_nomina;
            arrParam[10] = new OracleParameter("p_marca", OracleDbType.Int32);
            arrParam[10].Value = p_marca;
            arrParam[11] = new OracleParameter("p_fecha_proceso", OracleDbType.Date);
            arrParam[11].Value = DateTime .Now;
        	arrParam[12] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,4000);
			arrParam[12].Direction = ParameterDirection.Output;
				
			String cmdStr= "OFC_OFICIOS_PKG.Crear_Oficio";
                       

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[12].Value.ToString();			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}

		}

		
		public static string cancelaOficio(int idOficio, string usuario, string observacion)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
			arrParam[0].Value = idOficio; 
			arrParam[1] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2,35);
			arrParam[1].Value = usuario;
			arrParam[2] = new OracleParameter("p_observaciones_procesa", OracleDbType.NVarchar2,1000);
			arrParam[2].Value = observacion;
			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;
				
			String cmdStr= "OFC_OFICIOS_PKG.Cancelar_Oficios";

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


        public static string aplicaOficio(int idOficio, string usuario, string observacion, string IPAddress)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Int32);
			arrParam[0].Value = idOficio;
            arrParam[1] = new OracleParameter("p_observaciones_procesa", OracleDbType.NVarchar2, 1000);
            arrParam[1].Value = observacion;
            arrParam[2] = new OracleParameter("p_idusuario", OracleDbType.NVarchar2,35);
			arrParam[2].Value = usuario;
            arrParam[3] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[3].Value = IPAddress;
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;
				
			String cmdStr= "OFC_OFICIOS_PKG.Ejecucion_Oficios";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[4].Value.ToString();			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}


		}		

		
		public static string insertaDetOficio(int idOficio,string idRef,double montoOriginal,double recargos,string nss)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
			arrParam[0].Value = idOficio; 
			arrParam[1] = new OracleParameter("p_idreferencia", OracleDbType.NVarchar2,16);
			arrParam[1].Value = idRef;
			arrParam[2] = new OracleParameter("p_montoriginal", OracleDbType.Decimal);
			arrParam[2].Value = montoOriginal;
			arrParam[3] = new OracleParameter("p_recargos", OracleDbType.Decimal);
			arrParam[3].Value = recargos;
            arrParam[4] = new OracleParameter("p_nss", OracleDbType.Decimal);
            if (string.IsNullOrEmpty(nss))
            {
                 arrParam[4].Value = DBNull.Value;
            }
            else
            {
                arrParam[4].Value = nss;
            }
            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[5].Direction = ParameterDirection.Output;
			
			String cmdStr= "OFC_OFICIOS_PKG.Insertar_det_Oficio";

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

        public static string CargarDocumentacion(string id_oficio, byte[] documento,string nombre_documento,string tipo)
		{
			OracleParameter[] arrParam  = new OracleParameter[5];

			
			
            arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
            arrParam[0].Value = Convert.ToInt32(id_oficio);
			
            arrParam[1] = new OracleParameter("p_documento", OracleDbType.Blob);
			arrParam[1].Value = documento;
			
            arrParam[2] = new OracleParameter("p_DOCUMENTO_NOMBRE", OracleDbType.NVarchar2,100);
			arrParam[2].Value = nombre_documento;
			
            arrParam[3] = new OracleParameter("p_DOCUMENTO_TIPO", OracleDbType.NVarchar2, 50);
			arrParam[3].Value = tipo;
            
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "OFC_OFICIOS_PKG.cargarDoc";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				              
                var result = Utilitarios.Utils.sacarMensajeDeError(arrParam[4].Value.ToString());
		        return result;

			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}


		}

        //Retorna las documentos adjuntos que estan contenidos en un mismo idOficio
        public static DataTable getDocumentacion(string p_id_oficio)
        {
            
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
            arrParam[0].Value = Convert.ToDecimal(p_id_oficio);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "OFC_OFICIOS_PKG.getDocumentos";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                try
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
            }
        
        }


        public static DataTable getDoc(string p_id_doc)
        {
            byte[] img = null;
            OracleDataReader odr = null;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_doc", OracleDbType.Decimal);
            arrParam[0].Value = Convert.ToDecimal(p_id_doc);

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "OFC_OFICIOS_PKG.getDoc";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
               
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }

        }

        public static DataTable getEmpleadosActivos(string p_rnc_cedula,string p_id_nomina,int p_pagenum,int p_pagesize)
{
         
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2,11);
            arrParam[0].Value = p_rnc_cedula;

            arrParam[1] = new OracleParameter("p_id_nomina", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = p_id_nomina;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[2].Value = p_pagenum;
            
            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.Int32);
            arrParam[3].Value = p_pagesize;

            arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "OFC_OFICIOS_PKG.Get_empleados_act";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                try
                {
                    throw new Exception(arrParam[5].Value.ToString());
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
            }
        }

        public static DataTable ListarNominas(string p_rnc_cedula) {
            
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = p_rnc_cedula;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "OFC_OFICIOS_PKG.ListarNominas";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                try
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                catch (Exception ex1)
                {
                    throw ex1;
                }
            }
        }

        public static void MarcarArchivoConError(string id_recepcion)
        {

            string cmdStr = "OFC_OFICIOS_PKG.MarcarArchivo";
            string resultado = string.Empty;

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Int32);
            arrParam[0].Value = id_recepcion;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {

               DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                resultado = Utilitarios.Utils.sacarMensajeDeError(arrParam[1].Value.ToString());

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }

            if (!(resultado).Equals("OK"))
            {
                throw new Exception(resultado);
            }

        }

		#endregion
	
	}
}
