using System;
using SuirPlus;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;

namespace SuirPlus.Empresas
{
    /// <summary>
    /// Summary description for Certificaciones.
    /// </summary>
    public class Certificaciones
    {

        #region Miembros y Propiedades

        private string mRNC;
        private string mRazonSocial;
        private string mNombreComercial;
        private string mInicioActividades;
        private string mCedula;
        private string mNombre;
        private string mUsuario;
        private string mNss;
        private DateTime mFechaNacimiento;
        private string mNacionalidad;
        private int mNumero;
        private string mFechaDesde;
        private string mFechaHasta;
        private string mPeriodoDesde;
        private string mPeriodoHasta;
        private DateTime mFechaCreacion;
        private string mFirmaResponsable;
        private string mPuestoFirmaResponsable;
        private CertificacionType mTipo;
        private string mDescripcionTipo;
        private string mEncabezado;
        private string mEncabezadoNegativo;
        private string mPie;
        private string Package;
        private DataSet mDetalle;
        private DataSet mDeuda;
        private string mEstatus;
        public string NominaDes;
        private int mFirma;
        private string mComentario;
        private string mNoCertificacion;
        private int mPin;
        private string mTipoId;
        private Byte[] mFirmaImagen;
        private Byte[] mPDF;

        //Propiedades exclusva de la certificacion de Ultimo Aporte
        private string mNroReferencia;
        private string mPeriodoFactura;
        private double mUltimaRetencion;
        private double mSalarioSS;
        private double mMontofactura;
        private DateTime mFechaPago;


        public Double MonotFactura
        {
            get
            {
                return this.mMontofactura;
            }
            set
            {
                this.mMontofactura = value;
            }
        }
        public string NroReferencia
        {
            get { return this.mNroReferencia; }
        }

        public string PeriodoFactura
        {
            get { return this.mPeriodoFactura; }
        }

        public double UltimaRetencion
        {
            get { return this.mUltimaRetencion; }
        }

        public double SalarioSS
        {
            get { return this.mSalarioSS; }
        }

        public DateTime FechaPago
        {
            get { return this.mFechaPago; }
        }

        //***********************************************//

        //Propiedad de AportePersonal utilizado para la certificacion tipo 3 (Aporte Personal) y tipo 2 (Aporte empleado por empleador)
        private DataSet mAportes;
        private bool mExistenAporte = false;

        public DataSet Aportes
        {
            get { return this.mAportes; }
        }

        public bool ExistenAporte
        {
            get { return this.mExistenAporte; }
        }
        //*************************************************************//

        public string RNC
        {
            get
            {
                return this.mRNC.Trim();
            }
            set
            {
                this.mRNC = value.Trim();
            }
        }

        public string RazonSocial
        {
            get
            {
                return this.mRazonSocial;
            }
            set
            {
                this.mRazonSocial = value;
            }
        }

        public string NombreComercial
        {
            get
            {
                return this.mNombreComercial;
            }
            set
            {
                this.mNombreComercial = value;
            }
        }

        public string InicioActividades
        {
            get { return mInicioActividades; }
        }
        public string Cedula
        {
            get
            {
                return this.mCedula;
            }
            set
            {
                this.mCedula = value;
            }
        }

        public string Nombre
        {
            get
            {
                return this.mNombre;
            }
            set
            {
                this.mNombre = value;
            }
        }

        public string FirmaResponsable
        {
            get
            {
                return mFirmaResponsable;
            }
        }
        public int Firma
        {
            get { return mFirma; }
            set { mFirma = value; }
        }

        public string PuestoFirmaResponsable
        {
            get { return mPuestoFirmaResponsable; }
        }
        public string Usuario
        {
            get
            {
                return this.mUsuario;
            }
            set
            {
                this.mUsuario = value;
            }
        }

        public string NSS
        {
            get
            {
                return mNss;
            }
            set
            {
                mNss = value;
            }
        }
        public string Nacionalidad
        {
            get
            {
                return mNacionalidad;
            }
            set
            {
                mNacionalidad = value;
            }
        }
        public DateTime FechaNacimiento
        {
            get
            {
                return mFechaNacimiento;
            }

        }


        public int Numero
        {
            get
            {
                return this.mNumero;
            }
            set
            {
                this.mNumero = value;
            }
        }

        public string FechaDesde
        {
            get
            {
                return this.mFechaDesde;
            }
            set
            {
                this.mFechaDesde = value;
            }
        }

        public string FechaHasta
        {
            get
            {
                return this.mFechaHasta;
            }
            set
            {
                this.mFechaHasta = value;
            }
        }

        public string PeriodoDesde
        {
            get { return mPeriodoDesde; }
        }
        public string PeriodoHasta
        {
            get { return mPeriodoHasta; }
        }

        public string Encabezado
        {
            get { return mEncabezado; }
        }
        public string EncabezadoNegativo
        {
            get { return mEncabezadoNegativo; }
        }
        public string Pie
        {
            get { return mPie; }
        }
        public DateTime FechaCreacion
        {
            get { return mFechaCreacion; }
        }
        public CertificacionType Tipo
        {
            get
            {
                return this.mTipo;
            }
            set
            {
                mTipo = value;
            }
        }

        public string DescripcionTipo
        {
            get { return this.mDescripcionTipo; }
        }

        public DataSet Detalle
        {
            get { return this.mDetalle; }
        }
        public string Estatus
        {
            get
            {
                return this.mEstatus;
            }
            set
            {
                this.mEstatus = value;
            }
        }

        public string Comentario
        {
            get
            {
                return this.mComentario;
            }
            //set
            //{
            //    this.mComentario = value;
            //}
        }

        public string NoCertificacion
        {
            get
            {
                return this.mNoCertificacion;
            }
            set
            {
                this.mNoCertificacion = value;
            }
        }

        public int Pin
        {
            get
            {
                return this.mPin;
            }
            set
            {
                this.mPin = value;
            }
        }

        public string TipoId
        {
            get
            {
                return this.mTipoId;
            }
            set
            {
                this.mTipoId = value;
            }
        }

        public Byte[] FirmaImagen
        {
            get { return mFirmaImagen; }
            set { mFirmaImagen = value; }
        }

        public Byte[] PDF
        {
            get { return mPDF; }
            set { mPDF = value; }
        }


        #endregion


        public enum CertificacionType
        {
            EstatusPagoDetalle,
            AporteEmpleadoPorEmpleador,
            AportePersonal,
            BalanceAlDia,
            NoOperaciones,
            BalanceAlDiaCon3FacturasOMenosPagadas,
            RegistroPersonaFisicaSinNomina,
            RegistroEmpleadorSinNomina,
            CiudadanoSinAporte,
            UltimoAporteCiudadano,
            ReporteNoPagosEmpleadoAlEmpleador,
            Discapidad,
            IngresoTardio,
            NoDefinido,
            AcuerdoPagoCuotasRequeridas,
            BalanceAlDiaConNPDeAuditoriaVE,
            Deuda,
            RegistroIndustriaComercio,
            CiudadanoSinAportePorEmpleador,
            AcuerdoPagoSinAtraso,
            EstatusGeneral,
            CertificaciónNSSExtranjeros

        }

        /// <summary>
        /// Constructor de la clase utilizada para crear una certificacion.
        /// </summary>
        /// <param name="tipo">Indica el tipo de certificacion que se desea crear.</param>
        public Certificaciones(CertificacionType tipo)
        {
            this.mTipo = tipo;
        }


        /// <summary>
        /// Constructor de la clase utilizada obtener toda la informacion concerniente a una certificacion.
        /// </summary>
        /// <param name="Numero">ID de la certificacion que se desea consultar.</param>
        public Certificaciones(int Numero)
        {

            //Cargamos los datos de la certificacion
            this.mNumero = Numero;
            cargarCertificacion();

        }

        /// <summary>
        /// Constructor de la clase utilizada obtener toda la informacion concerniente a una certificacion.
        /// </summary>
        /// <param name="Numero">ID de la certificacion que se desea consultar.</param>
        public Certificaciones(string NoCertificacion)
        {

            //Cargamos los datos de la certificacion
            this.mNoCertificacion = NoCertificacion;
            cargarNoCertificacion();

        }


        /// <summary>
        /// Utilizado para cargar los datos de una certificacion
        /// cuando es proporcionado el id de la certificacion.
        /// </summary>
        private void cargarCertificacion()
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_certificacion", OracleDbType.Decimal);
            arrParam[0].Value = this.mNumero;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.getCertificacion";
            DataTable dtCertificacion = new DataTable();

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam);
                if (ds.Tables.Count > 0)

                //dtCertificacion =  DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package,arrParam).Tables[0];
                // if (dtCertificacion.Rows.Count > 0)
                {
                    dtCertificacion = ds.Tables[0];
                    this.mTipo = setTipoCertificacion(dtCertificacion.Rows[0]["Id_Tipo"].ToString());
                    this.mDescripcionTipo = dtCertificacion.Rows[0]["Descripcion"].ToString();
                    this.mUsuario = dtCertificacion.Rows[0]["id_usuario"].ToString();
                    this.mRNC = dtCertificacion.Rows[0]["rnc"].ToString();
                    this.mNss = dtCertificacion.Rows[0]["nss"].ToString();

                    if (dtCertificacion.Columns.Contains("fecha_nacimiento"))
                    {
                        if (dtCertificacion.Rows[0]["fecha_nacimiento"] != DBNull.Value)
                        {
                            this.mFechaNacimiento = Convert.ToDateTime(dtCertificacion.Rows[0]["fecha_nacimiento"]);
                        }
                    }
                    if (dtCertificacion.Columns.Contains("nacionalidad_des"))
                    {
                        this.Nacionalidad = dtCertificacion.Rows[0]["nacionalidad_des"].ToString();
                    }
                    this.mFechaCreacion = Convert.ToDateTime(dtCertificacion.Rows[0]["fecha_creacion"]);
                    this.mRazonSocial = dtCertificacion.Rows[0]["razonsocial"].ToString();
                    this.mNombreComercial = dtCertificacion.Rows[0]["nombre_comercial"].ToString();
                    this.mCedula = dtCertificacion.Rows[0]["cedula"].ToString();
                    this.mNombre = dtCertificacion.Rows[0]["nombre"].ToString();
                    this.mEncabezado = dtCertificacion.Rows[0]["encabezado_1"].ToString();
                    this.mEncabezadoNegativo = dtCertificacion.Rows[0]["encabezado_2"].ToString();
                    this.mPie = dtCertificacion.Rows[0]["pie_de_pagina"].ToString();
                    this.mInicioActividades = dtCertificacion.Rows[0]["fecha_inicio_actividades"].ToString();
                    this.mFirmaResponsable = dtCertificacion.Rows[0]["nombre_resp_firma"].ToString();
                    this.mPuestoFirmaResponsable = dtCertificacion.Rows[0]["puesto_resp_firma"].ToString();
                    this.mEstatus = dtCertificacion.Rows[0]["desc_status"].ToString();
                    this.mComentario = dtCertificacion.Rows[0]["Comentario"].ToString();
                    this.mNoCertificacion = dtCertificacion.Rows[0]["no_certificacion"].ToString();
                    this.mPin = Convert.ToInt32(dtCertificacion.Rows[0]["pin"].ToString());
                    this.mTipoId = dtCertificacion.Rows[0]["Id_Tipo"].ToString();
                    this.mFirmaImagen = (byte[])dtCertificacion.Rows[0]["firma_imagen"];
                    if (dtCertificacion.Rows[0]["Pdf"] != DBNull.Value)
                    {
                        this.mPDF = (byte[])dtCertificacion.Rows[0]["Pdf"];
                    }

                    if (this.mTipo == CertificacionType.UltimoAporteCiudadano)
                    {
                        mNroReferencia = dtCertificacion.Rows[0]["id_referencia"].ToString();
                        mPeriodoFactura = dtCertificacion.Rows[0]["periodo_factura"].ToString();
                        mUltimaRetencion = Convert.ToDouble(dtCertificacion.Rows[0]["retenciones"]);
                        mSalarioSS = Convert.ToDouble(dtCertificacion.Rows[0]["salario_ss"]);
                        mFechaPago = Convert.ToDateTime(dtCertificacion.Rows[0]["fecha_pago"]);
                    }
                    else
                    {
                        this.mFechaDesde = dtCertificacion.Rows[0]["fecha_desde"].ToString();
                        this.mFechaHasta = dtCertificacion.Rows[0]["fecha_hasta"].ToString();
                        this.mPeriodoDesde = dtCertificacion.Rows[0]["Periodo_Desde"].ToString();
                        this.mPeriodoHasta = dtCertificacion.Rows[0]["Periodo_Hasta"].ToString();
                    }


                    //Si es de aporte por empleador buscamos el detalle en cuestion.
                    if (this.mTipo == CertificacionType.AporteEmpleadoPorEmpleador)
                    {
                        this.mAportes = new DataSet();
                        this.mAportes.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mAportes.Tables[0].TableName = "Aportes";

                        if (mAportes.Tables[0].Rows.Count > 0)
                            this.mExistenAporte = true;
                    }

                    //Si es de aporte personal...cargamos un datatable con los empleadores
                    // y otro con el detalle de los aporte de cada empleador.
                    if (this.mTipo == CertificacionType.AportePersonal)
                    {
                        this.mAportes = new DataSet();
                        this.mAportes.Tables.Add(this.getDetalleCertificacion("3Empleador").Copy());
                        this.mAportes.Tables[0].TableName = "Empleadores";

                        this.mAportes.Tables.Add(this.getDetalleCertificacion("3Aporte").Copy());
                        this.mAportes.Tables[1].TableName = "Aportes";

                        if (mAportes.Tables[0].Rows.Count > 0)
                            this.mExistenAporte = true;
                    }

                    if (this.mTipo == CertificacionType.IngresoTardio || this.mTipo == CertificacionType.Discapidad)
                    {
                        this.mDetalle = new DataSet();
                        this.mDetalle.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mDetalle.Tables[0].TableName = "Detalle";
                    }

                    if (this.mTipo == CertificacionType.Deuda)
                    {
                        // NominaDes = dtCertificacion.Rows[0][""].ToString();
                        // mEstatus = dtCertificacion.Rows[0]["desc_status"].ToString();
                        // mNroReferencia = dtCertificacion.Rows[0]["id_referencia"].ToString();
                        //Montofactura = Convert.ToDouble(dtCertificacion.Rows[0]["total_importe"]);
                        this.mDetalle = new DataSet();
                        this.mDetalle.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mDetalle.Tables[0].TableName = "Detalle";


                    }

                    if (this.mTipo == CertificacionType.RegistroIndustriaComercio)
                    {
                        // NominaDes = dtCertificacion.Rows[0][""].ToString();
                        // mEstatus = dtCertificacion.Rows[0]["desc_status"].ToString();
                        // mNroReferencia = dtCertificacion.Rows[0]["id_referencia"].ToString();
                        //Montofactura = Convert.ToDouble(dtCertificacion.Rows[0]["total_importe"]);
                        this.mDetalle = new DataSet();
                        this.mDetalle.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mDetalle.Tables[0].TableName = "Detalle";


                    }

                    if (this.mTipo == CertificacionType.EstatusGeneral)
                    {
                        this.mDetalle = new DataSet();
                        this.mDetalle.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mDetalle.Tables[0].TableName = "Detalle";

                    }

                }
                else
                {
                    throw new Exception("No hay Data.");
                }

            }
            catch (OracleException oEx)
            {
                throw new Exception(oEx.Message);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// Utilizado para cargar los datos de una certificacion
        /// cuando es proporcionado el id de la certificacion.
        /// </summary>
        private void cargarNoCertificacion()
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_no_certificacion", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = this.mNoCertificacion;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.getCertificacion";
            DataTable dtCertificacion = new DataTable();

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam);
                if (ds.Tables.Count > 0)

                //dtCertificacion =  DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package,arrParam).Tables[0];
                // if (dtCertificacion.Rows.Count > 0)
                {
                    dtCertificacion = ds.Tables[0];
                    this.mNumero = Convert.ToInt32(dtCertificacion.Rows[0]["id_certificacion"].ToString());
                    this.mTipo = setTipoCertificacion(dtCertificacion.Rows[0]["Id_Tipo"].ToString());
                    this.mDescripcionTipo = dtCertificacion.Rows[0]["Descripcion"].ToString();
                    this.mUsuario = dtCertificacion.Rows[0]["id_usuario"].ToString();
                    this.mRNC = dtCertificacion.Rows[0]["rnc"].ToString();
                    this.mNss = dtCertificacion.Rows[0]["nss"].ToString();
                    this.mFechaCreacion = Convert.ToDateTime(dtCertificacion.Rows[0]["fecha_creacion"]);
                    this.mRazonSocial = dtCertificacion.Rows[0]["razonsocial"].ToString();
                    this.mNombreComercial = dtCertificacion.Rows[0]["nombre_comercial"].ToString();
                    this.mCedula = dtCertificacion.Rows[0]["cedula"].ToString();
                    this.mNombre = dtCertificacion.Rows[0]["nombre"].ToString();
                    this.mEncabezado = dtCertificacion.Rows[0]["encabezado_1"].ToString();
                    this.mEncabezadoNegativo = dtCertificacion.Rows[0]["encabezado_2"].ToString();
                    this.mPie = dtCertificacion.Rows[0]["pie_de_pagina"].ToString();
                    this.mInicioActividades = dtCertificacion.Rows[0]["fecha_inicio_actividades"].ToString();
                    this.mFirmaResponsable = dtCertificacion.Rows[0]["nombre_resp_firma"].ToString();
                    this.mPuestoFirmaResponsable = dtCertificacion.Rows[0]["puesto_resp_firma"].ToString();
                    this.mEstatus = dtCertificacion.Rows[0]["desc_status"].ToString();
                    this.mComentario = dtCertificacion.Rows[0]["Comentario"].ToString();
                    this.mNoCertificacion = dtCertificacion.Rows[0]["no_certificacion"].ToString();
                    this.mPin = Convert.ToInt32(dtCertificacion.Rows[0]["pin"].ToString());
                    this.mTipoId = dtCertificacion.Rows[0]["Id_Tipo"].ToString();
                    this.mFirmaImagen = (byte[])dtCertificacion.Rows[0]["firma_imagen"];
                    if (dtCertificacion.Rows[0]["Pdf"] != DBNull.Value)
                    {
                        this.mPDF = (byte[])dtCertificacion.Rows[0]["Pdf"];
                    }



                    if (this.mTipo == CertificacionType.UltimoAporteCiudadano)
                    {
                        mNroReferencia = dtCertificacion.Rows[0]["id_referencia"].ToString();
                        mPeriodoFactura = dtCertificacion.Rows[0]["periodo_factura"].ToString();
                        mUltimaRetencion = Convert.ToDouble(dtCertificacion.Rows[0]["retenciones"]);
                        mSalarioSS = Convert.ToDouble(dtCertificacion.Rows[0]["salario_ss"]);
                        mFechaPago = Convert.ToDateTime(dtCertificacion.Rows[0]["fecha_pago"]);
                    }
                    else
                    {
                        this.mFechaDesde = dtCertificacion.Rows[0]["fecha_desde"].ToString();
                        this.mFechaHasta = dtCertificacion.Rows[0]["fecha_hasta"].ToString();
                        this.mPeriodoDesde = dtCertificacion.Rows[0]["Periodo_Desde"].ToString();
                        this.mPeriodoHasta = dtCertificacion.Rows[0]["Periodo_Hasta"].ToString();
                    }


                    //Si es de aporte por empleador buscamos el detalle en cuestion.
                    if (this.mTipo == CertificacionType.AporteEmpleadoPorEmpleador)
                    {
                        this.mAportes = new DataSet();
                        this.mAportes.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mAportes.Tables[0].TableName = "Aportes";

                        if (mAportes.Tables[0].Rows.Count > 0)
                            this.mExistenAporte = true;
                    }

                    //Si es de aporte personal...cargamos un datatable con los empleadores
                    // y otro con el detalle de los aporte de cada empleador.
                    if (this.mTipo == CertificacionType.AportePersonal)
                    {
                        this.mAportes = new DataSet();
                        this.mAportes.Tables.Add(this.getDetalleCertificacion("3Empleador").Copy());
                        this.mAportes.Tables[0].TableName = "Empleadores";

                        this.mAportes.Tables.Add(this.getDetalleCertificacion("3Aporte").Copy());
                        this.mAportes.Tables[1].TableName = "Aportes";

                        if (mAportes.Tables[0].Rows.Count > 0)
                            this.mExistenAporte = true;
                    }

                    if (this.mTipo == CertificacionType.IngresoTardio || this.mTipo == CertificacionType.Discapidad)
                    {
                        this.mDetalle = new DataSet();
                        this.mDetalle.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mDetalle.Tables[0].TableName = "Detalle";
                    }

                    if (this.mTipo == CertificacionType.Deuda)
                    {
                        // NominaDes = dtCertificacion.Rows[0][""].ToString();
                        // mEstatus = dtCertificacion.Rows[0]["desc_status"].ToString();
                        // mNroReferencia = dtCertificacion.Rows[0]["id_referencia"].ToString();
                        //Montofactura = Convert.ToDouble(dtCertificacion.Rows[0]["total_importe"]);
                        this.mDetalle = new DataSet();
                        this.mDetalle.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mDetalle.Tables[0].TableName = "Detalle";


                    }

                    if (this.mTipo == CertificacionType.RegistroIndustriaComercio)
                    {
                        // NominaDes = dtCertificacion.Rows[0][""].ToString();
                        // mEstatus = dtCertificacion.Rows[0]["desc_status"].ToString();
                        // mNroReferencia = dtCertificacion.Rows[0]["id_referencia"].ToString();
                        //Montofactura = Convert.ToDouble(dtCertificacion.Rows[0]["total_importe"]);
                        this.mDetalle = new DataSet();
                        this.mDetalle.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mDetalle.Tables[0].TableName = "Detalle";


                    }

                    if (this.mTipo == CertificacionType.EstatusGeneral)
                    {
                        this.mDetalle = new DataSet();
                        this.mDetalle.Tables.Add(this.getDetalleCertificacion(null).Copy());
                        this.mDetalle.Tables[0].TableName = "Detalle";

                    }

                }
                else
                {
                    throw new Exception("No hay Data.");
                }

            }
            catch (OracleException oEx)
            {
                throw new Exception(oEx.Message);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }



        //Carga el Grid de Detalle de deudas.

        //public static DataTable CargarDetalleDeudas(int id_certificacion)
        //{
        //   OracleParameter[] arrParam;
        //    String cmdStr = "Cer_Certificaciones_Pkg.getCertificacion";

        //    DataTable dt = new DataTable();

        //     arrParam = new OracleParameter[3];

        //    arrParam[0] = new OracleParameter("p_id_certificacion", OracleDbType.Int32);
        //    arrParam[0].Value = id_certificacion;

        //    arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
        //    arrParam[1].Value = ParameterDirection.Output;

        //    arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
        //    arrParam[2].Direction = ParameterDirection.Output;



        //    try
        //    {
        //        DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

        //        if (arrParam[2].Value.ToString() != "0")
        //        {
        //            throw new Exception(arrParam[2].Value.ToString());
        //        }

        //        if (ds.Tables.Count > 0)
        //        {

        //            return ds.Tables[0];

        //        }

        //        return new DataTable("No Hay Data");
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }



        //}

        ////Carga el monto adeudado para un empleador para una certificacion.

        public Double getMontoAdeudado(int id_certificacion)
        {
            OracleParameter[] arrParam;
            String cmdStr = "Cer_Certificaciones_Pkg.getMontoAdeudado";

            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_certificacion", OracleDbType.Int32);
            arrParam[0].Value = id_certificacion;

            arrParam[1] = new OracleParameter("p_monto", OracleDbType.Double);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;



            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                String msg = string.Empty;
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                    //msg.Split('|')[1].ToString();
                }

                else
                {

                    mMontofactura = Convert.ToDouble(arrParam[1].Value.ToString());

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return this.mMontofactura;

        }


        /// <summary>
        /// Carga los datos de las propiedades segun el tipo de certificacion.
        /// </summary>
        public void CargarDatos()
        {
            if (mTipo == CertificacionType.AporteEmpleadoPorEmpleador ||
                mTipo == CertificacionType.ReporteNoPagosEmpleadoAlEmpleador ||
                mTipo == CertificacionType.CiudadanoSinAportePorEmpleador)
            {
                if (mCedula != null || mRNC != null)
                {
                    this.llenaDatosCiudadanos();
                    this.llenaDatosEmpleador();
                }
                else
                {
                    throw new Exception("Favor completar los datos de cédula y/o rnc.");
                }
            }
            else if (mTipo == CertificacionType.RegistroPersonaFisicaSinNomina)
            {
                //Para este caso, la cedula fue asiganda a la variable RNC por lo que verificamos si este es un empleador valido.
                if (mRNC != null)
                {
                    this.llenaDatosEmpleador();
                }
                else
                {
                    //RNC / Cedula del empleador Inválido
                    throw new Exception(Utilitarios.TSS.getErrorDescripcion(150));
                }

            }
            else if (mTipo == CertificacionType.BalanceAlDia ||
                   mTipo == CertificacionType.BalanceAlDiaCon3FacturasOMenosPagadas ||
                   mTipo == CertificacionType.RegistroEmpleadorSinNomina ||
                   mTipo == CertificacionType.EstatusPagoDetalle ||
                   mTipo == CertificacionType.NoOperaciones ||
                   mTipo == CertificacionType.AcuerdoPagoCuotasRequeridas ||
                   mTipo == CertificacionType.BalanceAlDiaConNPDeAuditoriaVE ||
                   mTipo == CertificacionType.AcuerdoPagoSinAtraso ||
                   mTipo == CertificacionType.EstatusGeneral)
            {
                //Llenamos los datos correspondiente a un empelador; si la variable mRnc no tiene valor disparamos una excepcion.
                if (mRNC != null)
                {
                    this.llenaDatosEmpleador();
                }
                else
                {
                    //RNC / Cedula del empleador Inválido
                    throw new Exception(Utilitarios.TSS.getErrorDescripcion(150));
                }
            }
            else if (mTipo == CertificacionType.AportePersonal ||
                mTipo == CertificacionType.CiudadanoSinAporte ||
                mTipo == CertificacionType.UltimoAporteCiudadano ||
                mTipo == CertificacionType.IngresoTardio ||
                mTipo == CertificacionType.Discapidad)
            {
                //Llenamos los datos correspondiente a un trabajador; si la variable mCedula no tiene valor entonces disparamos una excepcion.
                if (mCedula != null)
                {
                    this.llenaDatosCiudadanos();
                }
                else
                {	//Número de cédula inválido
                    throw new Exception(Utilitarios.TSS.getErrorDescripcion(103));
                }
            }

        }

        /// <summary>
        /// Metodo utilizado para crear una certificacion
        /// </summary>
        /// <param name="usuario">El usuario que crea la certificacion</param>
        public void Crear(string usuario)
        {
            string retorno = "0";
            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2, 35);
            arrParam[0].Value = usuario;

            arrParam[1] = new OracleParameter("p_id_tipo", OracleDbType.Varchar2, 2);
            arrParam[1].Value = getValorTipoCertificacion(this.mTipo);

            arrParam[2] = new OracleParameter("p_rnc_cedula", OracleDbType.Varchar2, 11);
            arrParam[2].Value = this.mRNC;

            arrParam[3] = new OracleParameter("p_idnss", OracleDbType.Int32, 10);
            arrParam[3].Value = this.mNss;

            //Metodo utilizado para sacar la firma y puesto responsable
            //getFirmante(usuario, CertificacionType.AcuerdoPagoCuotasRequeridas, ref mFirmaResponsable, ref mPuestoFirmaResponsable);
            //arrParam[4] = new OracleParameter("p_firma", OracleDbType.NVarchar2, 30);
            // arrParam[4].Value = this.mFirmaResponsable;
            arrParam[4] = new OracleParameter("p_id_firma", OracleDbType.Int32, 9);
            arrParam[4].Value = mFirma;

            arrParam[5] = new OracleParameter("p_fecha_desde", OracleDbType.Varchar2, 10);
            arrParam[5].Value = this.mFechaDesde;

            arrParam[6] = new OracleParameter("p_fecha_hasta", OracleDbType.Varchar2, 10);
            arrParam[6].Value = this.mFechaHasta;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 500);
            arrParam[7].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.CrearCertificacionesCer";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                retorno = arrParam[7].Value.ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("Error de ejecución en base de datos.");
            }

            //if (Utilitarios.Utils.esValorNumerico(retorno.Split('|')[0].ToString()))
            //{
            //    this.mNumero = int.Parse(retorno.Split('|')[0].ToString());
            //    this.mNoCertificacion = retorno.Split('|')[1].ToString();
            //}

            if (retorno.Split('|').Length == 3)
            {
                this.mNumero = int.Parse(retorno.Split('|')[0].ToString());
                this.mNoCertificacion = retorno.Split('|')[1].ToString();
            }
            else
            {
                throw new Exception(Utilitarios.Utils.sacarMensajeDeError(retorno));
            }

        }


        /// <summary>
        /// Verifica si un ciudadano esta en el padron, para su posterior validacion.
        /// </summary>
        /// <param name="mensaje">Si no esta en el padron, este mensaje se le muestra al usuario en la pantalla de certificacion.</param>
        /// <returns>True o False dependiendo si existe el ciudadano en el padron.</returns>
        public bool esCiudadano(ref string mensaje)
        {
            bool retorno = false;
            mensaje = "0";
            string msg = EsCiudadanoOEmpleador("C", this.mCedula);
            if (msg == "0")
            {
                retorno = true;
                mensaje = string.Empty;
            }
            else
            {
                mensaje = msg.Split('|')[1].ToString();
            }

            return retorno;

        }


        /// <summary>
        /// Verifica si un empleador esta registrado en la tabla de empleadores.
        /// </summary>
        /// <param name="mensaje">Si no esta en el padron, este mensaje se le muestra al usuario en la pantalla de certificacion.</param>
        /// <returns>True o False dependiendo si existe el ciudadano en el padron.</returns>
        public bool esEmpleador(ref string mensaje)
        {
            bool retorno = false;
            mensaje = "0";
            string msg = EsCiudadanoOEmpleador("E", this.mRNC);
            if (msg == "0")
            {
                retorno = true;
                mensaje = string.Empty;
            }
            else
            {
                mensaje = msg.Split('|')[1].ToString();
            }

            return retorno;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public DataTable getFactVencidas()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2);
            arrParam[0].Value = this.mRNC.Trim();

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.Get_Facturas_Vencidas";
            DataTable dtFactVencidas = new DataTable();

            try
            {
                dtFactVencidas = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam).Tables[0];
            }
            catch
            {
                throw new Exception("Error retornando las facturas vencidas.");
            }

            return dtFactVencidas;

        }


        /// <summary>
        /// Utilizado para verificar si un trabajador tiene aporte con un empleador en especifico.
        /// </summary>
        /// <remarks>By Ronny Carreras</remarks>
        /// <returns>Si o No si tiene aporte con el empleador especificado.</returns>
        public bool tieneAporteEmpleador()
        {
            bool tieneAporte = true;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC.Trim();

            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = this.mCedula.Trim();

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 25);
            arrParam[2].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.TieneAporte";


            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                if (arrParam[2].Value.ToString() == "N")
                    tieneAporte = false;

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return tieneAporte;

        }

        public bool tieneAporteCiudadanoEmpleador()
        {
            bool tieneAporte = true;
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC.Trim();

            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = this.mCedula.Trim();

            arrParam[2] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            arrParam[2].Value = Convert.ToDateTime(this.mFechaDesde);

            arrParam[3] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            arrParam[3].Value = Convert.ToDateTime(this.mFechaHasta);

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 25);
            arrParam[4].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.TieneAporte";


            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                if (arrParam[4].Value.ToString() == "N")
                    tieneAporte = false;

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return tieneAporte;

        }


        /// <summary>
        /// Utilizado para verificar si un trabajador ha realizado aportes a la SS
        /// </summary>
        /// <remarks>By Ronny Carreras</remarks>
        /// <returns>Si o No dependiendo si ha hecho aporte.</returns>
        public bool tieneAporteTrabajador()
        {

            bool tieneAporte = true;
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mCedula.Trim();

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 25);
            arrParam[1].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.TieneAporte";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                if (arrParam[1].Value.ToString() == "N")
                    tieneAporte = false;

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return tieneAporte;

        }



        public bool tieneAporteGeneral()
        {
            bool tieneAporte = true;
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC.Trim();

            arrParam[1] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            arrParam[1].Value = Convert.ToDateTime(this.mFechaDesde);

            arrParam[2] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            arrParam[2].Value = Convert.ToDateTime(this.mFechaHasta);

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 25);
            arrParam[3].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.TieneAporteGeneral";


            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                if (arrParam[3].Value.ToString() == "N")
                    tieneAporte = false;

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return tieneAporte;

        }


        /// <summary>
        /// Verifica si el trabajador tiene factura en estatus ‘PA’,‘VE’ y ‘VI’
        ///  o que tenga al menos una nomina con estatus ‘A’ o ‘B’.
        /// </summary>
        /// <returns>True o False</returns>
        public bool esIngresoTardio()
        {
            bool tieneAporte = true;
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mCedula.Trim();

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 25);
            arrParam[1].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.ElegibleIngresoTardio";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                if (arrParam[1].Value.ToString() == "N")
                    tieneAporte = false;

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return tieneAporte;

        }


        /// <summary>
        /// Metodo utilizado para verificar si un empleado ha realizado su ultimo aporte
        /// </summary>
        /// <param name="detalleAporte">Un Datatable que se pasa por referencia; si es true es nulo de lo contrario tiene registros</param>
        /// <returns>True o falso dependiendo si el trabajador ha realizado su ultimo aporte.</returns>
        public bool validoUltimoAporte(ref DataTable detalleAporte)
        {

            bool isValido = true;
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mCedula.Trim();

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.ValidaUltimoAporte";
            DataTable dtDetalle = new DataTable();

            try
            {
                dtDetalle = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam).Tables[0];
            }
            catch
            { }

            if (dtDetalle.Rows.Count > 0)
            {
                //Si el datatable contiene una columna que se llama estatus, significa que todo esta OK, por lo que retornamos true.
                if (dtDetalle.Columns[0].ColumnName != "STATUS")
                {
                    isValido = false;
                    detalleAporte = dtDetalle;
                }

            }

            return isValido;

        }


        public DataTable getDetalleOperaciones()
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2);
            arrParam[0].Value = this.RNC;

            arrParam[1] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            arrParam[1].Value = Convert.ToDateTime(this.FechaDesde);

            arrParam[2] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            arrParam[2].Value = Convert.ToDateTime(this.FechaHasta);

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.Get_Certificacion_No_Operacion";
            DataTable dtOperaciones = new DataTable();

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam);
                if (ds.Tables.Count == 0)
                {
                    // throw new Exception("No hay Data.");
                    dtOperaciones = new DataTable();
                }
                else
                {
                    dtOperaciones = ds.Tables[0];
                }

            }
            catch (OracleException oEx)
            {
                throw new Exception("Error retornando las operaciones del empleador. " + oEx.ToString());
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return dtOperaciones;

        }


        public DataTable getDetalleCertificacion(string tipoDetalle)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdCertificacion", OracleDbType.Decimal);
            arrParam[0].Value = this.mNumero;

            arrParam[1] = new OracleParameter("p_TipoDetalle", OracleDbType.NVarchar2, 25);
            arrParam[1].Value = tipoDetalle;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.getDetalleCertificacion";
            DataTable dtDetalle = new DataTable();

            dtDetalle = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam).Tables[0];

            return dtDetalle;
        }

        /// <summary>
        /// Utilizado para obtener las nominas de un empleador.
        /// </summary>
        /// <returns>Un Datatable con las nominas de un empleador.</returns>
        public DataTable getNominas()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.Get_Nominas_Empleador";
            DataTable dtNominas = new DataTable();

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam);
                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Data");
            }
            catch
            {
                throw new Exception("Error cargando las nominas.");
            }

            return dtNominas;
        }


        /// <summary>
        /// Procedimiento utilizado por el tipo de certificacion 7 y 8 y se usa para verificar si un empleador tiene facturas vigentes o pagadas para
        /// el periodo actual.
        /// </summary>
        /// <returns>Un datatable conm un resumen de las facturas encontradas.</returns>
        public bool tieneFacturasPeriodoActual(ref DataTable detalleFactura)
        {
            bool tieneFactura = false;
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.Existe_Factura";
            DataTable dtFacturas = new DataTable();

            try
            {
                dtFacturas = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam).Tables[0];
            }
            catch { }

            if (dtFacturas.Rows.Count > 0)
            {
                //Verificamos si la columna del datatable es "Estatus" significa que no tiene facturas que todo esta OK por lo que retornamos false.
                if (dtFacturas.Columns[0].ColumnName != "STATUS")
                {
                    tieneFactura = true;
                    detalleFactura = dtFacturas;

                }
            }

            return tieneFactura;

        }


        /// <summary>
        /// Esta funcion se utiliza para verificar que un empleador o un ciudadano este registrado en el sistema.
        /// </summary>
        /// <param name="aquienVerifica"></param>
        /// <returns>0 si fue encontrado o el mensaje de error.</returns>
        private string EsCiudadanoOEmpleador(string aquienVerifica, string RncCedula)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RncCedula;

            arrParam[1] = new OracleParameter("p_TipoVerificacion", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = aquienVerifica;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[2].Direction = ParameterDirection.Output;

            Package = "suirplus.Cer_Certificaciones_Pkg.Existe_Empleador_Ciudadano";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, Package, arrParam);
                return arrParam[2].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        /// <summary>
        /// Le asigna valor a las propiedades del ciudadano.
        /// </summary>
        private void llenaDatosCiudadanos()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mCedula;

            arrParam[1] = new OracleParameter("p_TipoVerificacion", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = "C";

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.Get_Empleador_Ciudadano";
            DataTable dtCiudadano = new DataTable();

            try
            {
                dtCiudadano = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam).Tables[0];
                this.mNss = dtCiudadano.Rows[0]["NSS"].ToString();
                this.mNombre = dtCiudadano.Rows[0]["NOMBRE"].ToString();
            }
            catch (OracleException oEx)
            {
                throw oEx;
            }
            catch
            {
                throw new Exception("Error cargando los datos del ciudadano.");
            }

        }


        /// <summary>
        /// le asigna valor a las propiedades del empleador.
        /// </summary>
        private void llenaDatosEmpleador()
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC.Trim();

            arrParam[1] = new OracleParameter("p_TipoVerificacion", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = "E";

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            Package = "Cer_Certificaciones_Pkg.Get_Empleador_Ciudadano";
            DataTable dtEmpleador = new DataTable();

            try
            {
                dtEmpleador = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam).Tables[0];
                this.mRazonSocial = dtEmpleador.Rows[0]["RAZON_SOCIAL"].ToString();
                this.mNombreComercial = dtEmpleador.Rows[0]["NOMBRE_COMERCIAL"].ToString();
                this.mInicioActividades = dtEmpleador.Rows[0]["INICIO_ACTIVIDADES"].ToString();
                //this.NSS = "11691450";//dtEmpleador.Rows[0]["NSS"].ToString();
            }
            catch (OracleException oEx)
            {
                throw oEx;
            }
            catch (Exception ex)
            {
                //throw new Exception("Error cargando los datos del empleador.");
                throw ex;
            }

        }


        /// <summary>
        /// Procedimiento utilizado por el tipo de certificacion 12 y se usa para verificar si un empleador tiene acuerdo de pago.
        /// </summary>
        /// <returns>Un bool indicando si tiene o no acuerdo de pago.</returns>
        public bool tieneEmpleadorAcuerdodePago()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 2);
            arrParam[1].Direction = ParameterDirection.Output;

            string pkg = "LGL_Legal_Pkg.isExisteEmpleadorConAcuerdo";

            bool resultado = false;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, pkg, arrParam);
                string valor = arrParam[1].Value.ToString();
                if (valor != "0")
                {
                    resultado = true;
                }


            }
            catch
            { }

            return resultado;

        }


        /// <summary>
        /// Procedimiento utilizado por el tipo de certificacion 12 y se usa para verificar si un empleador tiene una cuota vencida.
        /// </summary>
        /// <returns>Un bool indicando si tiene o no una cuota vencida.</returns>
        public bool IsAcuerdoVencido()
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 2);
            arrParam[2].Direction = ParameterDirection.Output;

            string pkg = "LGL_Legal_Pkg.IsAcuerdoVencido";

            bool resultado = false;

            DataTable dtVencidas = new DataTable();

            try
            {
                dtVencidas = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, pkg, arrParam).Tables[0];
            }
            catch { }


            int valor = Convert.ToInt16(dtVencidas.Rows[0]["CantidadVencida"].ToString());

            if (valor > 0)
            {
                resultado = true;
            }

            return resultado;

        }


        public bool tieneAcuerdodePagoVigente()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 2);
            arrParam[1].Direction = ParameterDirection.Output;

            string pkg = "Cer_Certificaciones_Pkg.isExisteEmpleadorConAcuerdo";

            bool resultado = false;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, pkg, arrParam);
                string valor = arrParam[1].Value.ToString();
                if (valor != "0")
                {
                    resultado = true;
                }


            }
            catch
            { }

            return resultado;

        }

        public DataTable getCuotasPagadasAcuerdo(ref string resultado)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_RncCedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.RNC;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 2);
            arrParam[2].Direction = ParameterDirection.Output;



            Package = "Cer_Certificaciones_Pkg.CuotasPagadasAcuerdo";
            DataTable dtOperaciones = new DataTable();

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, Package, arrParam);
                resultado = arrParam[2].Value.ToString();

                if (resultado == "0")
                {
                    dtOperaciones = ds.Tables[0];
                }


            }
            catch
            { }

            return dtOperaciones;

        }

        /// <summary>
        /// Procedimiento utilizado por el tipo de certificacion 13 y se usa para verificar si un empleador cumple con el requisito de estar al dia y tener una NP de auditoría VE.
        /// </summary>
        /// <returns>Un bool indicando si aplica o no.</returns>
        public bool EmpleadorAlDiaConNPdeAuditoriaVE()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = this.mRNC;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 2);
            arrParam[1].Direction = ParameterDirection.Output;

            string pkg = "CER_CERTIFICACIONES_Pkg.isAlDiaConNPdeAuditoriaVE";

            bool resultado = false;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, pkg, arrParam);
                string valor = arrParam[1].Value.ToString();
                if (valor != "0")
                {
                    resultado = true;
                }


            }
            catch
            { }

            return resultado;

        }


        #region Funciones Estaticas


        /// <summary>
        /// Retorna los tipos de certificacion que se pueden realizar.
        /// </summary>
        /// <param name="onLine">Se especifica si los tipos de certificacion que se quieren obtener se pueden hacer online</param>
        /// <returns>Un datatable con los Tipo de Certificacion</returns>
        public static DataTable getTipoCertificacion(bool onLine)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_OnLine", OracleDbType.NVarchar2, 2);
            arrParam[0].Value = (onLine == true) ? "S" : "N";

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "Cer_Certificaciones_Pkg.getTipoCertificaciones";
            DataTable dt = new DataTable();

            try
            {
                dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch
            {

            }

            return dt;
        }

        /// <summary>
        /// Retorna 1 si el tipo de certificacion esta activa y 0 si esta inactiva.
        /// </summary>
        /// <param name="IdTipoCertificacion"></param>
        /// <returns></returns>
        public static string getTipoCertificacionActiva(string IdTipoCertificacion)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_tipo_certificacion", OracleDbType.NVarchar2, 2);
            arrParam[0].Value = IdTipoCertificacion;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "Cer_Certificaciones_Pkg.getTipoCertificacionActiva";
            string result = string.Empty;

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

        public static DataTable getTipoCertificaciones()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "Cer_Certificaciones_Pkg.GetTipoCertificacion";
            DataTable dt = new DataTable();

            try
            {
                dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch
            {

            }

            return dt;
        }

        public static DataTable getTipoCertificacionesPorRol(int Id_Rol)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_rol", OracleDbType.Int32);
            arrParam[0].Value = Id_Rol;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "Cer_Certificaciones_Pkg.GetCertificacionPorRol";
            DataTable dt = new DataTable();

            try
            {
                dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch
            {

            }

            return dt;
        }


        /// <summary>
        /// Utilizado para obtener el valor en string de un tipo de certificacion
        /// </summary>
        /// <param name="tipoCertificacion">El tipo de certificacion tipo CertificacionType</param>
        /// <returns>un string con el valor del tipo de certificacion.</returns>
        public static string getValorTipoCertificacion(CertificacionType tipoCertificacion)
        {
            switch (tipoCertificacion)
            {

                case CertificacionType.EstatusPagoDetalle:
                    return "1";
                case CertificacionType.AporteEmpleadoPorEmpleador:
                    return "2";
                case CertificacionType.AportePersonal:
                    return "3";
                case CertificacionType.NoOperaciones:
                    return "4";
                case CertificacionType.BalanceAlDia:
                    return "5";
                case CertificacionType.BalanceAlDiaCon3FacturasOMenosPagadas:
                    return "6";
                case CertificacionType.RegistroPersonaFisicaSinNomina:
                    return "7";
                case CertificacionType.RegistroEmpleadorSinNomina:
                    return "8";
                case CertificacionType.IngresoTardio:
                    return "9";
                case CertificacionType.Discapidad:
                    return "10";
                case CertificacionType.CiudadanoSinAporte:
                    return "A";
                case CertificacionType.UltimoAporteCiudadano:
                    return "B";
                case CertificacionType.ReporteNoPagosEmpleadoAlEmpleador:
                    return "C";
                case CertificacionType.AcuerdoPagoCuotasRequeridas:
                    return "12";
                case CertificacionType.Deuda:
                    return "13";
                case CertificacionType.RegistroIndustriaComercio:
                    return "15";
                case CertificacionType.CiudadanoSinAportePorEmpleador:
                    return "16";
                case CertificacionType.AcuerdoPagoSinAtraso:
                    return "17";
                case CertificacionType.EstatusGeneral:
                    return "18";
                case CertificacionType.CertificaciónNSSExtranjeros:
                    return "88";
                default:
                    return null;
            }
        }

        //*************************
        public static DataTable consultaCert(string idCertificacion, string rncCedula, string cedula)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_numCert", OracleDbType.Int32);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idCertificacion);

            arrParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(rncCedula);

            arrParam[2] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 11);
            arrParam[2].Value = SuirPlus.Utilitarios.Utils.verificarNulo(cedula);

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.InputOutput;


            String cmdStr = "CER_CERTIFICACIONES_PKG.consCert";
            String Resultado = "";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[4].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable();
                    Utilitarios.Utils.agregarMensajeError(Resultado, ref dt);
                    return dt;
                }

                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                throw new Exception(Resultado);
            }
        }


        public static void getFirmante(string usuario, CertificacionType tipoCertificacion,
            ref string firmaResponsable, ref string puestoResponsable)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_TipoCertificacion", OracleDbType.NVarchar2, 2);
            arrParam[0].Value = getValorTipoCertificacion(tipoCertificacion);

            arrParam[1] = new OracleParameter("p_IdUsuario", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = usuario;

            arrParam[2] = new OracleParameter("p_Firma", OracleDbType.NVarchar2, 30);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_Puesto", OracleDbType.NVarchar2, 100);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 20);
            arrParam[4].Direction = ParameterDirection.Output;

            string pkg = "Cer_Certificaciones_Pkg.getFirmaResponsable";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, pkg, arrParam);

                if (arrParam[4].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[4].Value.ToString());
                }

                firmaResponsable = arrParam[2].Value.ToString();
                puestoResponsable = arrParam[3].Value.ToString();

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        /// <summary>
        /// Funcion Utilizada para establecer un tipo de certificiacion basado en un valor en string
        /// </summary>
        /// <param name="tipo">Valor que representa un tipo de certificacion</param>
        /// <returns>Un Tipo de certificacion CertificacionType</returns>
        public static Certificaciones.CertificacionType setTipoCertificacion(string tipo)
        {
            switch (tipo)
            {
                case "1":
                    return CertificacionType.EstatusPagoDetalle;
                case "2":
                    return CertificacionType.AporteEmpleadoPorEmpleador;
                case "3":
                    return CertificacionType.AportePersonal;
                case "4":
                    return CertificacionType.NoOperaciones;
                case "5":
                    return CertificacionType.BalanceAlDia;
                case "6":
                    return CertificacionType.BalanceAlDiaCon3FacturasOMenosPagadas;
                case "7":
                    return CertificacionType.RegistroPersonaFisicaSinNomina;
                case "8":
                    return CertificacionType.RegistroEmpleadorSinNomina;
                case "9":
                    return CertificacionType.IngresoTardio;
                case "10":
                    return CertificacionType.Discapidad;
                case "A":
                    return CertificacionType.CiudadanoSinAporte;
                case "B":
                    return CertificacionType.UltimoAporteCiudadano;
                case "C":
                    return CertificacionType.ReporteNoPagosEmpleadoAlEmpleador;
                case "12":
                    return CertificacionType.AcuerdoPagoCuotasRequeridas;
                case "13":
                    return CertificacionType.Deuda;
                case "14":
                    return CertificacionType.BalanceAlDiaConNPDeAuditoriaVE;
                case "15":
                    return CertificacionType.RegistroIndustriaComercio;
                case "16":
                    return CertificacionType.CiudadanoSinAportePorEmpleador;
                case "17":
                    return CertificacionType.AcuerdoPagoSinAtraso;
                case "18":
                    return CertificacionType.EstatusGeneral;
                case "88":
                    return CertificacionType.CertificaciónNSSExtranjeros;
                default:
                    return CertificacionType.NoDefinido;

            }
        }


        /// <summary>
        /// Funcion utilizada al momento de generar una certificacion tipo 7 u 8
        /// </summary>
        /// <param name="rnc">El RNC o cedula del empleador</param>
        /// <returns>El periodo de la ultima fectura pagada por el empleador en caso de que haya una.</returns>
        public static string getPeriodoUltimaFactura(string rnc)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Rnc_Cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 20);
            arrParam[1].Direction = ParameterDirection.Output;

            string pkg = "Cer_Certificaciones_Pkg.Get_Periodo_UltimaFactura";
            string resultado = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, pkg, arrParam);
                resultado = arrParam[1].Value.ToString();

            }
            catch
            { }

            return resultado;

        }

        #endregion

        //nuevos metodos para la automaticacion de las certificaciones...
        public static DataTable getCertificaciones(string idCertificacion, string no_documento, string rncCedula, string cedula, int idStatus, string tipo, int pageNum, int pageSize, string fechaDesde, string fechaHasta)
        {


            OracleParameter[] arrParam = new OracleParameter[12];

            arrParam[0] = new OracleParameter("p_numCert", OracleDbType.Int32);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idCertificacion);

            arrParam[1] = new OracleParameter("p_no_certificacion", OracleDbType.NVarchar2, 25);
            arrParam[1].Value = no_documento;

            arrParam[2] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[2].Value = SuirPlus.Utilitarios.Utils.verificarNulo(rncCedula);

            arrParam[3] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 11);
            arrParam[3].Value = SuirPlus.Utilitarios.Utils.verificarNulo(cedula);

            arrParam[4] = new OracleParameter("p_id_status", OracleDbType.Int32);
            if (idStatus != 0)
            {
                arrParam[4].Value = idStatus;
            }
            else
            {
                arrParam[4].Value = DBNull.Value;
            }
            //el parametro tipo es para identificar los registro que se van a mostrar segun la pantalla que lo requiera.
            arrParam[5] = new OracleParameter("p_tipo", OracleDbType.Varchar2);
            arrParam[5].Value = tipo;

            arrParam[6] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[6].Value = pageNum;
            arrParam[7] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[7].Value = pageSize;

            arrParam[8] = new OracleParameter("p_desde", OracleDbType.Date);
            if (fechaDesde != string.Empty)
            {
                arrParam[8].Value = Convert.ToDateTime(fechaDesde);
            }
            else
            {
                arrParam[8].Value = DBNull.Value;
            }
            arrParam[9] = new OracleParameter("p_hasta", OracleDbType.Date);

            if (fechaHasta != string.Empty)
            {
                arrParam[9].Value = Convert.ToDateTime(fechaHasta);
            }
            else
            {
                arrParam[9].Value = DBNull.Value;
            }
            arrParam[10] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[10].Direction = ParameterDirection.Output;

            arrParam[11] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[11].Direction = ParameterDirection.InputOutput;


            String cmdStr = "CER_CERTIFICACIONES_PKG.getCertificaciones";
            String Resultado = "";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[11].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable();
                    Utilitarios.Utils.agregarMensajeError(Resultado, ref dt);
                    return dt;
                }

                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Metodo utilizado para obtener la documentación scaneada de una certificación.
        /// </summary>
        /// <returns>Un Byte[] con la informacion indicada.</returns>
        /// <remarks>By Charlie L. Peña</remarks>
        /// 
        public static Byte[] getImagenCertificacion(int idCertificacion)
        {
            byte[] img = null;
            OracleDataReader odr = null;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_Certificacion", OracleDbType.Int32);
            arrParam[0].Value = idCertificacion;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "CER_CERTIFICACIONES_PKG.getImagenCertificacion";

            try
            {
                odr = DataBase.OracleHelper.ExecuteDataReader(CommandType.StoredProcedure, cmdStr, arrParam);
                if (odr.HasRows)
                {
                    odr.Read();
                    if (!odr.IsDBNull(0))
                    {
                        img = new byte[(odr.GetBytes(0, 0, null, 0, int.MaxValue))];
                        odr.GetBytes(0, 0, img, 0, img.Length);
                    }

                }

                odr.Close();

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }

            return img;

        }

        public static string SubirImagenCertificacion(int idCertificacion, int IdFirma, Byte[] imageFile, string idUsuario)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_certificacion", OracleDbType.NVarchar2);
            arrParam[0].Value = idCertificacion;
            arrParam[1] = new OracleParameter("p_imagen", OracleDbType.Blob);
            arrParam[1].Value = imageFile;
            arrParam[2] = new OracleParameter("p_id_firma", OracleDbType.NVarchar2);

            if (IdFirma != 0)
            {
                arrParam[2].Value = IdFirma;
            }
            else
            {
                arrParam[2].Value = DBNull.Value;
            }


            arrParam[3] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 35);
            arrParam[3].Value = idUsuario;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "CER_CERTIFICACIONES_PKG.subirImAgenCertificacion";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        public static string CambiarStatusCert(int idCertificacion, int idStatus, string idUsuario, string comentario)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_certificacion", OracleDbType.NVarchar2);
            arrParam[0].Value = idCertificacion;
            arrParam[1] = new OracleParameter("p_id_status_certificacion", OracleDbType.Int32);
            arrParam[1].Value = idStatus;
            arrParam[2] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2, 35);
            arrParam[2].Value = idUsuario;
            arrParam[3] = new OracleParameter("p_comentario", OracleDbType.Varchar2);
            arrParam[3].Value = comentario;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "CER_CERTIFICACIONES_PKG.CambiarStatusCert";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        public static DataTable getFirmasOficinas()
        {
            OracleParameter[] arrParam = new OracleParameter[2];


            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "cer_certificaciones_pkg.getfirmasoficinas";
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

        public static DataTable getStatusCertificaciones()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "cer_certificaciones_pkg.getstatuscertificaciones";
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

        public static DataTable GetInfoSolicitud(string rncCedula, string p_id_usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("P_RNC_O_CEDULA", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rncCedula;

            arrParam[1] = new OracleParameter("P_ID_USUARIO", OracleDbType.NVarchar2);
            arrParam[1].Value = p_id_usuario;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "cer_certificaciones_pkg.GET_INFO_GENERAL";
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

        public static string ProcesarSolicitud(string Usuario, string tipoCertificacion, string rnc_cedula, string nro_documento, string fechadesde, string fechahasta)
        {

            OracleParameter[] arrParam = new OracleParameter[7];


            String cmdStr = "CER_CERTIFICACIONES_PKG.ProcesarSolicitud";

            arrParam[0] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2);
            arrParam[0].Value = Usuario;

            arrParam[1] = new OracleParameter("p_id_tipo", OracleDbType.NVarchar2);
            arrParam[1].Value = tipoCertificacion;

            arrParam[2] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2);
            arrParam[2].Value = rnc_cedula;

            arrParam[3] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[3].Value = nro_documento;

            arrParam[4] = new OracleParameter("p_fecha_desde", OracleDbType.NVarchar2, 10);
            arrParam[4].Value = fechadesde;

            arrParam[5] = new OracleParameter("p_fecha_hasta", OracleDbType.NVarchar2, 10);
            arrParam[5].Value = fechahasta;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[6].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        public static DataTable GetSolicitudCertificacion(string Tipo, string rnc_cedula, string Usuario, string nro_documento, int id_certificacion, string no_autorizacion, string fechaDesde, string fechaHasta, int pagenum, int pageSize)
        {


            OracleParameter[] arrParam = new OracleParameter[12];

            arrParam[0] = new OracleParameter("p_id_tipo", OracleDbType.NVarchar2);
            if (Tipo != string.Empty)
            {
                arrParam[0].Value = Tipo;
            }
            else
            {
                arrParam[0].Value = null;
            }


            arrParam[1] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = rnc_cedula;

            arrParam[2] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2);
            arrParam[2].Value = Usuario;

            arrParam[3] = new OracleParameter("p_nro_documento", OracleDbType.NVarchar2, 25);
            arrParam[3].Value = nro_documento;

            arrParam[4] = new OracleParameter("p_id_certificacion", OracleDbType.Int32);
            if (id_certificacion == 0)
            {
                arrParam[4].Value = null;
            }
            else
            {
                arrParam[4].Value = id_certificacion;
            }


            arrParam[5] = new OracleParameter("p_no_certificacion", OracleDbType.NVarchar2);
            arrParam[5].Value = no_autorizacion;

            arrParam[6] = new OracleParameter("p_fecha_desde", OracleDbType.NVarchar2);
            if (fechaDesde != string.Empty)
            {
                var desde = Convert.ToDateTime(fechaDesde).ToShortDateString();
                arrParam[6].Value = desde;
            }
            else
            {
                arrParam[6].Value = null;
            }

            arrParam[7] = new OracleParameter("p_fecha_hasta", OracleDbType.NVarchar2);
            if (fechaHasta != string.Empty)
            {
                var hasta = Convert.ToDateTime(fechaHasta).ToShortDateString();
                arrParam[7].Value = hasta;
            }
            else
            {
                arrParam[7].Value = null;
            }

            arrParam[8] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[8].Value = pagenum;

            arrParam[9] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[9].Value = pageSize;

            arrParam[10] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[10].Direction = ParameterDirection.Output;

            arrParam[11] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[11].Direction = ParameterDirection.Output;



            String cmdStr = "cer_certificaciones_pkg.getSolitudCert";
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

        public static DataTable GetDescripcionTipoCertificacion(string rnc_cedula, string Usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("P_RNC_O_CEDULA", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc_cedula;

            arrParam[1] = new OracleParameter("p_id_usuario", OracleDbType.NVarchar2);
            arrParam[1].Value = Usuario;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "cer_certificaciones_pkg.GET_INFO_CERT";
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

        public static DataTable getIdCertificacion(string codigo, int pin)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("P_CERTIFICACION", OracleDbType.NVarchar2);
            arrParam[0].Value = codigo;

            arrParam[1] = new OracleParameter("P_PIN", OracleDbType.Double);
            arrParam[1].Value = pin;

            arrParam[2] = new OracleParameter("P_IOCURSOR", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("P_RESULTNUMBER", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "cer_certificaciones_pkg.GET_ID_CERTIFICACION";
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

        public static string getTrabajador(Int32 id_registro_patronal, string documento)
        {
            OracleParameter[] arrParam;
            String cmdStr = "cer_certificaciones_pkg.gettrabajador";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = id_registro_patronal;

            arrParam[1] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2);
            arrParam[1].Value = documento;


            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable getTotalCert(DateTime fechadesde, DateTime fechahasta, string id_usuario, string rnc_o_cedula, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            arrParam[0].Value = fechadesde;

            arrParam[1] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            arrParam[1].Value = fechahasta;

            arrParam[2] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2);
            arrParam[2].Value = id_usuario;

            arrParam[3] = new OracleParameter("p_rnc_cedula", OracleDbType.Varchar2);
            arrParam[3].Value = rnc_o_cedula;

            arrParam[4] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[4].Value = pagenum;

            arrParam[5] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[5].Value = pagesize;

            arrParam[6] = new OracleParameter("P_IOCURSOR", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("P_RESULTNUMBER", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;

            String cmdStr = "cer_certificaciones_pkg.get_total_cert";
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



        public static string ActualizarPDFCertificacion(int idCertificacion, Byte[] imageFile, string idUsuario)
        {

            OracleParameter[] arrParam = new OracleParameter[4];


            arrParam[0] = new OracleParameter("p_pdf", OracleDbType.Blob);
            arrParam[0].Value = imageFile;
            arrParam[1] = new OracleParameter("p_id_certificacion", OracleDbType.NVarchar2);
            arrParam[1].Value = idCertificacion;
            arrParam[2] = new OracleParameter("p_id_usuario", OracleDbType.Varchar2, 35);
            arrParam[2].Value = idUsuario;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "CER_CERTIFICACIONES_PKG.ActualizarPDF";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        public static DataTable getCertificacionesOFV(string idCertificacion, string no_documento, string tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_numCert", OracleDbType.Int32);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idCertificacion);

            arrParam[1] = new OracleParameter("p_documento", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(no_documento);

            arrParam[2] = new OracleParameter("p_tipo", OracleDbType.Varchar2);
            arrParam[2].Value = tipo;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.InputOutput;


            String cmdStr = "oficina_virtual_pkg.getCertificacionesOFV";
            String Resultado = "";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[4].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable();
                    Utilitarios.Utils.agregarMensajeError(Resultado, ref dt);
                    return dt;
                }

                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string SolicitudCertificacionOFV(string idCertificacion, string no_documento)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_documento", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(no_documento);

            arrParam[1] = new OracleParameter("p_id_tipo_cert", OracleDbType.NVarchar2);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(idCertificacion);

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.InputOutput;

            String cmdStr = "OFICINA_VIRTUAL_PKG.ProcesarCertificacionesOFV";
            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[2].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
    }

}
