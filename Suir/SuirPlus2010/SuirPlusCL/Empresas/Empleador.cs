using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Empresas
{
	/// <summary>
	/// Clase que representa al objeto Empleador.
    /// <remarks>Modificada para la V2.0 by Ronny Carreras</remarks>
	/// </summary>
	public partial class Empleador : FrameWork.Objetos 
	{
        		
	   #region "Constructores de la Clase"
        
      public Empleador(int registroPatronal)
		{
			this.myRegistroPatronal = registroPatronal;
            
			this.myRncCedula = "";
			this.CargarDatos();
		}

		public Empleador(string rncCedula)
		{
			this.myRncCedula = rncCedula;
			this.myRegistroPatronal = -1;
			this.CargarDatos();
		}

    
        #endregion

        
		#region "Metodos de la clase"

		public override void CargarDatos()
		{

			DataTable dt = null;
			
			try
			{
				
	            dt = Empleador.getEmpleador(this.myRegistroPatronal,this.myRncCedula);

                if (dt.Rows.Count > 0)
                {
                    this.myRegistroPatronal = Convert.ToInt32(dt.Rows[0]["ID_REGISTRO_PATRONAL"].ToString());
                    this.myFactorRiesgo = dt.Rows[0]["FACTOR_RIESGO"].ToString();
                    this.myIdMotivoNoImpresion = dt.Rows[0]["ID_MOTIVO_NO_IMPRESION"].ToString();
                    this.RutaDistribucion = ((dt.Rows[0]["RUTA_DISTRIBUCION"] is DBNull) ? -1 : Convert.ToInt32(dt.Rows[0]["RUTA_DISTRIBUCION"].ToString()));
                    this.IDSectorEconomico = ((dt.Rows[0]["ID_SECTOR_ECONOMICO"] is DBNull) ? -1 : Convert.ToInt32(dt.Rows[0]["ID_SECTOR_ECONOMICO"].ToString()));

                    if (!(dt.Rows[0]["FECHA_INICIO_ACTIVIDADES"] is DBNull))
                    {
                        if (!DateTime.TryParse(dt.Rows[0]["FECHA_INICIO_ACTIVIDADES"].ToString(), out this.myFechaInicioActividades))
                        {
                            SuirPlus.Exepciones.Log.LogToDB("Error en fecha, Carga de Empleadores. RegPat:" + dt.Rows[0]["ID_REGISTRO_PATRONAL"].ToString() + "| Fecha:" + dt.Rows[0]["FECHA_INICIO_ACTIVIDADES"].ToString());
                        }
                    }

                    if (!(dt.Rows[0]["FECHA_NAC_CONST"] is DBNull))
                    {
                        if (!DateTime.TryParse(dt.Rows[0]["FECHA_NAC_CONST"].ToString(), out this.MyFechaConstitucion))
                        {
                            SuirPlus.Exepciones.Log.LogToDB("Error en fecha, Carga de Empleadores. RegPat:" + dt.Rows[0]["ID_REGISTRO_PATRONAL"].ToString() + "| Fecha:" + dt.Rows[0]["FECHA_NAC_CONST"].ToString()); 
                        }
                    }

                    this.myIdActividadEconomica = dt.Rows[0]["ID_ACTIVIDAD_ECO"].ToString();
                    this.myIdRiesgo = dt.Rows[0]["ID_RIESGO"].ToString();
                    this.myIdMunicipio = dt.Rows[0]["ID_MUNICIPIO"].ToString();
                    this.myMunicipio = dt.Rows[0]["municipio_des"].ToString();
                    this.myRncCedula = dt.Rows[0]["RNC_O_CEDULA"].ToString();
                    this.myRazonSocial = dt.Rows[0]["RAZON_SOCIAL"].ToString();
                    ////this.myPermitirPago = dt.Rows[0]["PERMITIR_PAGO"].ToString() == "N";

                    //if (this.myPermitirPago == false)
                    //{
                    //    this.myPermitirPago = true;
                    //}
                    //else
                    //{
                    //    this.myPermitirPago = false;
                    //}

                    this.myCompletoEncuesta = dt.Rows[0]["COMPLETO_ENCUESTA"].ToString() == "S";
                    this.myNombreComercial = dt.Rows[0]["NOMBRE_COMERCIAL"].ToString();
                    this.myEstatus = dt.Rows[0]["STATUS"].ToString();
                    this.myCalle = dt.Rows[0]["CALLE"].ToString();
                    this.myNumero = dt.Rows[0]["NUMERO"].ToString();
                    this.myEdificio = dt.Rows[0]["EDIFICIO"].ToString();
                    this.myPiso = dt.Rows[0]["PISO"].ToString();
                    this.myApartamento = dt.Rows[0]["APARTAMENTO"].ToString();
                    this.mySector = dt.Rows[0]["SECTOR"].ToString();
                    this.myTelefono1 = dt.Rows[0]["TELEFONO_1"].ToString();
                    this.myExt1 = dt.Rows[0]["EXT_1"].ToString();
                    this.myTelefono2 = dt.Rows[0]["TELEFONO_2"].ToString();
                    this.myExt2 = dt.Rows[0]["EXT_2"].ToString();
                    this.myFax = dt.Rows[0]["FAX"].ToString();
                    this.myEmail = dt.Rows[0]["EMAIL"].ToString();
                    this.myTipoEmpresa = dt.Rows[0]["TIPO_EMPRESA"].ToString();
                    this.myIdOficio = ((dt.Rows[0]["ID_OFICIO"] is DBNull) ? -1 : Convert.ToInt32(dt.Rows[0]["ID_OFICIO"].ToString()));
                    this.myDescuentoPenalidad = ((dt.Rows[0]["DESCUENTO_PENALIDAD"] is DBNull) ? (decimal)-1.0 : Convert.ToDecimal(dt.Rows[0]["DESCUENTO_PENALIDAD"].ToString()));
                    this.myCapital = ((dt.Rows[0]["CAPITAL"] is DBNull) ? (decimal)0.0 : Convert.ToDecimal(dt.Rows[0]["CAPITAL"].ToString()));
                  
                    this.myNoPagaIDSS = dt.Rows[0]["NO_PAGA_IDSS"].ToString();

                    if (!(dt.Rows[0]["FECHA_REGISTRO"] is DBNull))
                    {
                        if (!DateTime.TryParse(dt.Rows[0]["FECHA_REGISTRO"].ToString(), out this.myFechaRegistro))
                        {
                            SuirPlus.Exepciones.Log.LogToDB("Error en fecha, Carga de Empleadores. RegPat:" + dt.Rows[0]["ID_REGISTRO_PATRONAL"].ToString() + "| Fecha:" + dt.Rows[0]["FECHA_REGISTRO"].ToString());
                        }
                    }                                    
                    this.myProvincia = dt.Rows[0]["provincia_des"].ToString();
                    this.mySectorEconomico = dt.Rows[0]["sector_economico_des"].ToString();
                    this.myAdministradoraLocal = dt.Rows[0]["administracion_local_des"].ToString();
                    this.myActividadEconomina = dt.Rows[0]["actividad_eco_des"].ToString();
                    //this.myTieneMovimientoPendiente = (dt.Rows[0]["movimientos"].ToString()) == "Si";
                    this.myIdProvincia = dt.Rows[0]["ID_PROVINCIA"].ToString();
                    //this.myMotivoNoImpresion = dt.Rows[0]["MOTIVO_NO_IMPRESION_DES"].ToString();
                    this.mySectorSalarial = dt.Rows[0]["SECTOR_SALARIAL"].ToString();
                    this.myCodSector = ((dt.Rows[0]["COD_SECTOR"] is DBNull) ? -1 : Convert.ToInt32(dt.Rows[0]["COD_SECTOR"].ToString()));
                    this.mySalarioMinimoVigente = ((dt.Rows[0]["salario_minimo_vigente"] is DBNull) ? (decimal)0.0 : Convert.ToDecimal(dt.Rows[0]["salario_minimo_vigente"].ToString()));

                    switch (dt.Rows[0]["status_cobro"].ToString())
                    {
                        case "L":
                            this.myStatusCobro = StatusCobrosType.Legal;
                            break;
                        case "C":
                            this.myStatusCobro = StatusCobrosType.Cobros;
                            break;
                        case "A":
                            this.myStatusCobro = StatusCobrosType.Auditoria;
                            break;
                        case "R":
                            this.myStatusCobro = StatusCobrosType.Rectificacion;
                            break;
                        default:
                            this.myStatusCobro = StatusCobrosType.Normal;
                            break;
                    }

                    myTieneAcuerdoPago = dt.Rows[0]["Tiene_acuerdo"].ToString();


                    //if (!(dt.Rows[0]["id_motivo_cobro"] is DBNull))
                    //    this.myIdMotivoCobro = Int32.Parse(dt.Rows[0]["id_motivo_cobro"].ToString());

                    if (!(dt.Rows[0]["paga_infotep"] is DBNull))
                    {
                        this.myPagaInfotep = dt.Rows[0]["paga_infotep"].ToString();
                    }
                    else
                    {
                        this.myPagaInfotep = "N";
                    }
                    
                    this.myPagaMDT = dt.Rows[0]["paga_mdt"].ToString() == "N" ? false : true;
                   
                    this.myPagoDiscapacidad = dt.Rows[0]["PAGO_DISCAPACIDAD"].ToString(); 

                    dt.Dispose();
                    dt = null;
                }

            }
			catch(Exception ex)
			{
                throw ex;
			}
 
  
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{
			
			OracleParameter[] orParam = new OracleParameter[30];

			orParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
			orParam[0].Value = this.RegistroPatronal;

			orParam[1] = new OracleParameter("p_id_motivo_no_impresion", OracleDbType.NVarchar2,2);
            orParam[1].Value = myIdMotivoNoImpresion;

			orParam[2] = new OracleParameter("p_id_sector_economico", OracleDbType.Decimal);
			orParam[2].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.IDSectorEconomico);

			orParam[3] = new OracleParameter("p_id_oficio", OracleDbType.Decimal);
			if(this.IDOficio == -1)
				orParam[3].Value = DBNull.Value;
			else
				orParam[3].Value = this.IDOficio;

			orParam[4] = new OracleParameter("p_id_actividad_eco", OracleDbType.NVarchar2,6);
			orParam[4].Value = this.IDActividadEconomica;

			orParam[5] = new OracleParameter("p_id_riesgo", OracleDbType.NVarchar2,3);
			orParam[5].Value = this.IDRiesgo;

			orParam[6] = new OracleParameter("p_id_municipio", OracleDbType.NVarchar2,6);
			orParam[6].Value = this.IDMunicipio;

			orParam[7] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2,11);
			orParam[7].Value = this.RNCCedula;

			orParam[8] = new OracleParameter("p_razon_social", OracleDbType.NVarchar2,150);
			orParam[8].Value = this.RazonSocial;

			orParam[9] = new OracleParameter("p_nombre_comercial", OracleDbType.NVarchar2,150);
			orParam[9].Value = this.NombreComercial;

			orParam[10] = new OracleParameter("p_status", OracleDbType.NVarchar2,1);
			orParam[10].Value = this.Estatus;

			orParam[11] = new OracleParameter("p_calle", OracleDbType.NVarchar2,150);
			orParam[11].Value = this.Calle; 

			orParam[12] = new OracleParameter("p_numero", OracleDbType.NVarchar2,12);
			orParam[12].Value = this.Numero; 

			orParam[13] = new OracleParameter("p_edificio", OracleDbType.NVarchar2,25);
			orParam[13].Value = this.Edificio; 

			orParam[14] = new OracleParameter("p_piso", OracleDbType.NVarchar2,2);
			orParam[14].Value = this.Piso;
 
			orParam[15] = new OracleParameter("p_apartamento", OracleDbType.NVarchar2,10);
			orParam[15].Value = this.Apartamento;
 
			orParam[16] = new OracleParameter("p_sector", OracleDbType.NVarchar2,150);
			orParam[16].Value = this.Sector;
 
			orParam[17] = new OracleParameter("p_telefono_1", OracleDbType.NVarchar2,10);
			orParam[17].Value = this.Telefono1; 

			orParam[18] = new OracleParameter("p_ext_1", OracleDbType.NVarchar2,4);
			orParam[18].Value = this.Ext1;
 
			orParam[19] = new OracleParameter("p_telefono_2", OracleDbType.NVarchar2,10);
			orParam[19].Value = this.Telefono2; 

			orParam[20] = new OracleParameter("p_ext_2", OracleDbType.NVarchar2,4);
			orParam[20].Value = this.Ext2; 

			orParam[21] = new OracleParameter("p_fax", OracleDbType.NVarchar2,10);
			orParam[21].Value = this.Fax;
 
			orParam[22] = new OracleParameter("p_email", OracleDbType.NVarchar2,50);
			orParam[22].Value = this.Email; 

			orParam[23] = new OracleParameter("p_tipo_empresa", OracleDbType.NVarchar2,2);
			orParam[23].Value = this.TipoEmpresa;
 
			orParam[24] = new OracleParameter("p_descuento_penalidad", OracleDbType.Decimal);
			orParam[24].Value = 0; //this.DescuentoPenalidad; 

			orParam[25] = new OracleParameter("p_ruta_distribucion", OracleDbType.Decimal);
			if (this.RutaDistribucion == -1)
			{
				orParam[25].Value = DBNull.Value;
			}
			else
			{
				orParam[25].Value = this.RutaDistribucion;
			}
			orParam[26] = new OracleParameter("p_no_paga_idss", OracleDbType.NVarchar2,1);
			orParam[26].Value = this.NoPagaIDSS; 

			orParam[27] = new OracleParameter("p_completo_encuesta", OracleDbType.NVarchar2, 1);
			orParam[27].Value = "S";

            orParam[28] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            orParam[28].Value = UsuarioResponsable;

          			       
            orParam[29] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[29].Direction = ParameterDirection.Output;
                      
			try
			{
				OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"sre_empleadores_pkg.empleadores_editar",orParam);	
				return orParam[29].Value.ToString();
			}

			catch(Exception ex)
			{	
				throw ex;
				//return ex.ToString();
			}

		}

      #endregion

	}


  


}
