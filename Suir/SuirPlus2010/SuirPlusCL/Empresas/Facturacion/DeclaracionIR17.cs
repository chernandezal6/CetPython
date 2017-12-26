using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas.Facturacion
{
	/// <summary>
	/// Summary description for DeclaracionIR17.
	/// </summary>
	public class DeclaracionIR17 : SuirPlus.FrameWork.Objetos 
	{
		#region Propiedades Internas

		internal Int32 myRegistroPatronal;
		internal string myPeriodo;
		internal decimal myAlquileres;
		internal decimal myHonorariosServicios;
		internal decimal myPremios;
		internal decimal myTransferenciaTitulos;
		internal decimal myDividendos;
		internal decimal myInteresesExterior;
		internal decimal myRemesasExterior;
		internal decimal myProvedorEstado;
		internal decimal myOtrasRentas;
        internal decimal myOtrasRetenciones;
		internal decimal myRetribucionesComplementarias;
		internal decimal myPagosComputables;
		internal string myIdReferencia;
		internal string myStatus;
		internal Int32 myNoAutorizacion;
		decimal mySaldoFavorAnterior;
		DateTime myFecha, myFechaLimite;
		string myUsuario;

		#endregion

		#region Propiedades Publicas
		
		public DateTime FechaLimite
		{
			get {return this.myFechaLimite;}
		}
		public DateTime Fecha
		{
			get{return this.myFecha;}
		}
		public Int32 NoAutorizacion
		{
			get {return this.myNoAutorizacion;}
		}
		public string Usuario
		{
			get {return this.myUsuario;}
		}
		public string Status
		{
			get {return this.myStatus;}
		}
		public Int32 RegistroPatronal
		{
			get{return this.myRegistroPatronal;}
			set{this.myRegistroPatronal = value;}
		}
		public string Periodo
		{
			get{return this.myPeriodo;}
			set{this.myPeriodo = value;}
		}
		public decimal Alquileres
		{
			get {return this.myAlquileres;}
			set{this.myAlquileres = value;}
		}
		public decimal HonorariosServicios
		{
			get {return this.myHonorariosServicios;}
			set {this.myHonorariosServicios = value;}
		}
		public decimal Premios
		{
			get {return this.myPremios;}
			set {this.myPremios = value;}
		}
		public decimal TransferenciaTitulos
		{
			get {return this.myTransferenciaTitulos;}
			set {this.myTransferenciaTitulos = value;}
		}
		public decimal Dividendos
		{
			get {return this.myDividendos;}
			set {this.myDividendos = value;}
		}
		public decimal InteresesExterior
		{
			get {return this.myInteresesExterior;}
			set {this.myInteresesExterior = value;}
		}
		public decimal RemesasExterior
		{
			get {return this.myRemesasExterior;}
			set {this.myRemesasExterior = value;}
		}
		public decimal ProvedorEstado
		{
			get {return this.myProvedorEstado;}
			set {this.myProvedorEstado = value;}
		}
		public decimal OtrasRentas
		{
			get {return this.myOtrasRentas;}
			set {this.myOtrasRentas = value;}
		}
        public decimal OtrasRetenciones
        {
            get { return this.myOtrasRetenciones; }
            set { this.myOtrasRetenciones = value; }
        }
		public decimal RetribucionesComplementarias
		{
			get {return this.myRetribucionesComplementarias;}
			set {this.myRetribucionesComplementarias = value;}
		}
		public decimal PagosComputables
		{
			get {return this.myPagosComputables;}
			set {this.myPagosComputables= value;}
		}
		public decimal SaldoFavorAnterior
		{
			get {return this.mySaldoFavorAnterior;}
			set {this.mySaldoFavorAnterior = value;}
		}
		public string IdReferencia
		{
			get
			{
				return this.myIdReferencia;
			}

		}
		public string IdReferenciaFormat
		{
			get
			{
				return this.myIdReferencia.Substring(0,4) + "-" + this.myIdReferencia.Substring(4,4) + "-" + this.myIdReferencia.Substring(8,4) + "-" + this.myIdReferencia.Substring(12,4);
			}

		}
		#endregion
        
		public DeclaracionIR17(Int32 RegPatronal, string Periodo)
		{
			myRegistroPatronal = RegPatronal;
			myPeriodo = Periodo;
			this.CargarDatos();
		}
	
		public override void CargarDatos()
		{
			OracleParameter[] arrParam = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_regpatronal", OracleDbType.Decimal);
			arrParam[0].Value = this.RegistroPatronal;

			arrParam[1] = new OracleParameter("p_periodo", OracleDbType.NVarchar2,6);
			arrParam[1].Value = this.Periodo;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

			

			DataTable dt;
            try
            {
                dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_IR17_PKG.GetDeclaracion", arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(Convert.ToString(this.RegistroPatronal));
                SuirPlus.Exepciones.Log.LogToDB(this.Periodo);
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw;
            }
			
				if (dt.Rows.Count > 0)
				{

					myAlquileres = decimal.Parse(dt.Rows[0]["alquileres"].ToString());
					myHonorariosServicios = decimal.Parse(dt.Rows[0]["honorarios_servicios"].ToString());
					myPremios = decimal.Parse(dt.Rows[0]["premios"].ToString());
					myTransferenciaTitulos = decimal.Parse(dt.Rows[0]["transferencia_titulos"].ToString());
					myDividendos = decimal.Parse(dt.Rows[0]["dividendos"].ToString());
					myInteresesExterior = decimal.Parse(dt.Rows[0]["interes_exterior"].ToString());
					myRemesasExterior = decimal.Parse(dt.Rows[0]["remesas_exterior"].ToString());
					myProvedorEstado = decimal.Parse(dt.Rows[0]["provedor_estado"].ToString());
					myOtrasRentas = decimal.Parse(dt.Rows[0]["otras_rentas"].ToString());
                    myOtrasRetenciones = decimal.Parse(dt.Rows[0]["otras_retenciones"].ToString());
					myRetribucionesComplementarias = decimal.Parse(dt.Rows[0]["ret_complementarias"].ToString());
					myPagosComputables = decimal.Parse(dt.Rows[0]["pagos_computables_cuenta"].ToString());
					mySaldoFavorAnterior = decimal.Parse(dt.Rows[0]["saldo_favor_anterior"].ToString());
					myFecha = DateTime.Parse(dt.Rows[0]["ult_fecha_act"].ToString());
					myUsuario = dt.Rows[0]["ult_usuario_act"].ToString();
					myIdReferencia = dt.Rows[0]["ID_REFERENCIA_IR17"].ToString();
					myFechaLimite = DeclaracionIR17.getFechaLimitePeriodo(Int32.Parse(this.Periodo));
					myStatus = dt.Rows[0]["status"].ToString();
					myNoAutorizacion = Int32.Parse(dt.Rows[0]["no_autorizacion"].ToString());
				}
				else
				{
					throw new Exception("Nro. de Referencia Inválido");
				}
				
				dt.Dispose();
			
			
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{

			OracleParameter[] arrParam  = new OracleParameter[17];

			arrParam[0] = new OracleParameter("p_regpatronal", OracleDbType.Decimal);
			arrParam[0].Value = this.RegistroPatronal;
 
			arrParam[1] = new OracleParameter("p_periodo", OracleDbType.Decimal);
			arrParam[1].Value = this.Periodo; 

			arrParam[2] = new OracleParameter("p_alquileres", OracleDbType.Decimal);
			arrParam[2].Value = this.Alquileres; 

			arrParam[3] = new OracleParameter("p_honorarios_serv", OracleDbType.Decimal);
			arrParam[3].Value = this.HonorariosServicios; 

			arrParam[4] = new OracleParameter("p_premios", OracleDbType.Decimal);
			arrParam[4].Value = this.Premios; 

			arrParam[5] = new OracleParameter("p_transf_titulos", OracleDbType.Decimal);
			arrParam[5].Value = this.TransferenciaTitulos; 

			arrParam[6] = new OracleParameter("p_dividendos", OracleDbType.Decimal);
			arrParam[6].Value = this.Dividendos; 

			arrParam[7] = new OracleParameter("p_interes_exterior", OracleDbType.Decimal);
			arrParam[7].Value = this.InteresesExterior; 

			arrParam[8] = new OracleParameter("p_remesas_exterior", OracleDbType.Decimal);
			arrParam[8].Value = this.RemesasExterior; 

			arrParam[9] = new OracleParameter("p_provedor_estado", OracleDbType.Decimal);
			arrParam[9].Value = this.ProvedorEstado; 

			arrParam[10] = new OracleParameter("p_otras_rentas", OracleDbType.Decimal);
			arrParam[10].Value = this.OtrasRentas; 

			arrParam[11] = new OracleParameter("p_ret_complementarias", OracleDbType.Decimal);
			arrParam[11].Value = this.RetribucionesComplementarias; 

            arrParam[12] = new OracleParameter("p_saldo_favor_anterior", OracleDbType.Decimal);
            arrParam[12].Value = this.SaldoFavorAnterior;

            arrParam[13] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[13].Value = UsuarioResponsable;

			arrParam[14] = new OracleParameter("p_pagos_computables", OracleDbType.Decimal);
			arrParam[14].Value = this.PagosComputables;

            arrParam[15] = new OracleParameter("p_otras_retenciones", OracleDbType.Decimal);
            arrParam[15].Value = this.OtrasRetenciones;
            
			arrParam[16] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[16].Direction = ParameterDirection.Output;
				
			String cmdStr= "SFC_IR17_PKG.actualizadeclaracion";
			
			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[16].Value.ToString();			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
			}

		}

        #region " Funciones Estaticas "

		public static string getSaldoFavor(Int32 RegistroPatronal, string Periodo )
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_regpatronal", OracleDbType.Decimal);
			arrParam[0].Value = RegistroPatronal; 
			arrParam[1] = new OracleParameter("p_periodo", OracleDbType.Decimal);
			arrParam[1].Value = Int32.Parse(Periodo); 
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,200);
			arrParam[2].Direction = ParameterDirection.Output;
				
			String cmdStr= "SFC_IR17_PKG.GetSaldo";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[2].Value.ToString();			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
				return "0";
				//throw new Exception(RegistroPatronal.ToString() + " " + Periodo);
			}
		}
	
		//Tasas

		//Alquileres
		public static int getTazaAlquileres()
		{
			return DeclaracionIR17.getParametro(60);
		}
        
		//Optener un parametro de tasa cualquira
		public static int getParametro(int parametroId)
		{
			OracleParameter[] arrParam = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_parametro", OracleDbType.Decimal);
			arrParam[0].Value = parametroId;

			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			

			DataTable dt;
			dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "Srp_Mantenimiento_Pkg.GetDetalleParametros", arrParam).Tables[0];

			return int.Parse(dt.Rows[0][4].ToString());

		}
		
		public static string NuevaDeclaracion(Int32 RegistroPatronal, 
			string Periodo, 
			decimal Alquileres, 
			decimal HonorariosServicios, 
			decimal Premios, 
			decimal TransferenciaTitulos, 
			decimal	Dividendos, 
			decimal InteresesExterior, 
			decimal RemesasExterior, 
			decimal ProvedorEstado, 
			decimal OtrasRentas,
            decimal OtrasRetenciones,
			decimal RetribucionesComplementarias, 
			decimal PagosComputables, 
			decimal SaldoFavorAnterior,
			string usuarioAct)
		{
			OracleParameter[] arrParam  = new OracleParameter[17];

			arrParam[0] = new OracleParameter("p_regpatronal", OracleDbType.Decimal);
			arrParam[0].Value = RegistroPatronal; 
			
            arrParam[1] = new OracleParameter("p_periodo", OracleDbType.Decimal);
			arrParam[1].Value = Periodo; 
			
            arrParam[2] = new OracleParameter("p_alquileres", OracleDbType.Double);
			arrParam[2].Value = Alquileres; 
			
            arrParam[3] = new OracleParameter("p_honorarios_serv", OracleDbType.Double);
			arrParam[3].Value = HonorariosServicios; 
			
            arrParam[4] = new OracleParameter("p_premios", OracleDbType.Double);
			arrParam[4].Value = Premios; 
			
            arrParam[5] = new OracleParameter("p_transf_titulos", OracleDbType.Double);
			arrParam[5].Value = TransferenciaTitulos; 
			
            arrParam[6] = new OracleParameter("p_dividendos", OracleDbType.Double);
			arrParam[6].Value = Dividendos; 
			
            arrParam[7] = new OracleParameter("p_interes_exterior", OracleDbType.Double);
			arrParam[7].Value = InteresesExterior; 
			
            arrParam[8] = new OracleParameter("p_remesas_exterior", OracleDbType.Double);
			arrParam[8].Value = RemesasExterior; 
			
            arrParam[9] = new OracleParameter("p_provedor_estado", OracleDbType.Double);
			arrParam[9].Value = ProvedorEstado; 
			
            arrParam[10] = new OracleParameter("p_otras_rentas", OracleDbType.Double);
			arrParam[10].Value = OtrasRentas; 
			
            arrParam[11] = new OracleParameter("p_ret_complementarias", OracleDbType.Double);
			arrParam[11].Value = RetribucionesComplementarias; 
			
            arrParam[12] = new OracleParameter("p_saldo_favor_anterior", OracleDbType.Double);
			arrParam[12].Value = SaldoFavorAnterior; 
			
            arrParam[13] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2, 35);
			arrParam[13].Value = usuarioAct;
			
            arrParam[14] = new OracleParameter("p_pagos_computables", OracleDbType.Decimal);
			arrParam[14].Value = PagosComputables;

            arrParam[15] = new OracleParameter("p_otras_retenciones", OracleDbType.Decimal);
            arrParam[15].Value = OtrasRetenciones;

			arrParam[16] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[16].Direction = ParameterDirection.Output;
				
			String cmdStr= "SFC_IR17_PKG.NuevaDeclaracion";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return arrParam[16].Value.ToString();			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}
		}

		/// <summary>
		/// Metodo para verificar si la persona tiene ya una declaración en este periodo.
		/// </summary>
		/// <param name="RegistroPatronal">Registro Patronal</param>
		/// <param name="Periodo">Periodo Actual</param>
		/// <returns></returns>
		public static Boolean isTieneDeclaracionVigente(Int32 RegistroPatronal)
		{

			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_regpatronal", OracleDbType.NVarchar2,20);
			arrParam[0].Value = RegistroPatronal;
			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,1);
			arrParam[1].Direction = ParameterDirection.Output;
				
			String cmdStr= "SFC_IR17_PKG.isTieneDeclaracionVigente";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return (arrParam[1].Value.ToString()=="1");			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
			}

		}

		/// <summary>
		/// Metodo para verificar si la persona tiene ya una declaración en este periodo.
		/// </summary>
		/// <param name="RegistroPatronal">Registro Patronal</param>
		/// <param name="Periodo">Periodo Actual</param>
		/// <returns></returns>
		public static Boolean isPuedeModificarLaDeclaracionDelMes(Int32 RegistroPatronal, string Periodo)
		{
			return true;
		}

		/// <summary>
		/// Metodo para verificar si estamos dentro de los primeros 10 dias habiles del mes.
		/// </summary>
		/// <returns></returns>
		public static Boolean isTiempoParaHacerDeclaracion()
		{

			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,1);
			arrParam[0].Direction = ParameterDirection.Output;
				
			String cmdStr= "SFC_IR17_PKG.isTiempoParaHacerDeclaracion";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return (arrParam[0].Value.ToString()=="1");			
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
			}

		}

		public static DateTime getFechaLimite()
		{
			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.Date);
			arrParam[0].Direction = ParameterDirection.Output;
				
			String cmdStr= "SFC_IR17_PKG.fecha_limite";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return DateTime.Parse(arrParam[0].Value.ToString());
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			}

		}

		public static DateTime getFechaLimitePeriodo(Int32 periodo)
		{
			OracleParameter[] arrParam  = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_periodo", OracleDbType.Decimal);
			arrParam[0].Value = periodo;			
			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Date);
			arrParam[1].Direction = ParameterDirection.Output;
				
			String cmdStr= "SFC_IR17_PKG.fecha_limite_periodo";

			try
			{
				DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				return DateTime.Parse(arrParam[1].Value.ToString());
			}
			catch(Exception ex)
			{
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
			}

		}

	}

		#endregion


}
