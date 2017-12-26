using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Legal
{
    public class AcuerdosDePago : FrameWork.Objetos
    {

        private int mIdAcuerdo;
        private string mRNC;
        private string mRazonSocial;
        private string mTelefono1;
        private string mTelefono2;
        private string mFechaReg;
        private string mFechaTerm;
        private eTiposAcuerdos mTipo;
        private string mTipoAcuerdo;
        private string mStatus;
        private string mPeriodoIni;
        private string mPeriodoFin;
        private string mNombres;
        private string mNoDocumento;
        private string mTipoDocumento;
        private string mDireccion;
        private string mProvincia;
        private string mEstadoCivil;
        private string mNacionalidad;
        private string mRegPatronal;
        private string mCargo;
        private string mCuotas;

        public int idAcuerdo
        {
            get
            {
                return mIdAcuerdo;
            }
        }

        public eTiposAcuerdos tipo
        {
            get
            {
                return mTipo;
            }
            set
            {
                this.mTipo = value;
            }
        }

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
                return this.mRazonSocial.Trim();
            }
            set
            {
                this.mRazonSocial = value.Trim();
            }
        }
        public string Telefono1
        {
            get
            {
                return this.mTelefono1.Trim();
            }
            set
            {
                this.mTelefono1 = value.Trim();
            }
        }
        public string Telefono2
        {
            get
            {
                return this.mTelefono2.Trim();
            }
            set
            {
                this.mTelefono2 = value.Trim();
            }
        }
        public string FechaReg
        {
            get
            {
                return this.mFechaReg.Trim();
            }
            set
            {
                this.mFechaReg = value.Trim();
            }
        }
        public string FechaTerm
        {
            get
            {
                return this.mFechaTerm.Trim();
            }
            set
            {
                this.mFechaTerm = value.Trim();
            }
        }
        public string TipoAcuerdo
        {
            get
            {
                return this.mTipoAcuerdo.Trim();
            }
            set
            {
                this.mTipoAcuerdo = value.Trim();
            }
        }
        public string Status
        {
            get
            {
                return this.mStatus.Trim();
            }
            set
            {
                this.mStatus = value.Trim();
            }
        }
        public string PeriodoIni
        {
            get
            {
                return this.mPeriodoIni.Trim();
            }
            set
            {
                this.mPeriodoIni = value.Trim();
            }
        }
        public string PeriodoFin
        {
            get
            {
                return this.mPeriodoFin.Trim();
            }
            set
            {
                this.mPeriodoFin = value.Trim();
            }
        }
        public string Nombres
        {
            get
            {
                return this.mNombres.Trim();
            }
            set
            {
                this.mNombres = value.Trim();
            }
        }
        public string NoDocumento
        {
            get
            {
                return this.mNoDocumento.Trim();
            }
            set
            {
                this.mNoDocumento = value.Trim();
            }
        }
        public string TipoDocumento
        {
            get
            {
                return this.mTipoDocumento.Trim();
            }
            set
            {
                this.mTipoDocumento = value.Trim();
            }
        }
        public string Direccion
        {
            get
            {
                return this.mDireccion.Trim();
            }
            set
            {
                this.mDireccion = value.Trim();
            }
        }
        public string Provincia
        {
            get
            {
                return this.mProvincia.Trim();
            }
            set
            {
                this.mProvincia = value.Trim();
            }
        }
        public string EstadoCivil
        {
            get
            {
                return this.mEstadoCivil.Trim();
            }
            set
            {
                this.mEstadoCivil = value.Trim();
            }
        }
        public string Nacionalidad
        {
            get
            {
                return this.mNacionalidad.Trim();
            }
            set
            {
                this.mNacionalidad = value.Trim();
            }
        }
        public string RegPatronal
        {
            get
            {
                return this.mRegPatronal.Trim();
            }
            set
            {
                this.mRegPatronal = value.Trim();
            }
        }
        public string Cargo
        {
            get
            {
                return this.mCargo.Trim();
            }
            set
            {
                this.mCargo = value.Trim();
            }
        }
        public string Cuotas
        {
            get
            {
                return this.mCuotas.Trim();
            }
            set
            {
                this.mCuotas = value.Trim();
            }
        }

        public AcuerdosDePago(int IdAcuerdo,eTiposAcuerdos tipo)
        {
            this.mTipo = tipo;
            this.mIdAcuerdo = IdAcuerdo;
            this.CargarDatos();

        }

        public override void CargarDatos()
        {
            DataTable dtInfo;
            string result = "0";
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_idAcuerdo", OracleDbType.Int32);
            arrParam[0].Value = this.mIdAcuerdo;

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = this.mTipo;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getAcuerdoPago";

            try
            {

                dtInfo = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                result = arrParam[3].Value.ToString();

                if (result != "0")
                {
                    string[] ErrorMsg = result.Split('|');
                    throw new Exception(ErrorMsg[1]);
                }

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


            try
            {
                this.mNombres = dtInfo.Rows[0]["NOMBRES"].ToString();
                this.mRNC = dtInfo.Rows[0]["RNC_O_CEDULA"].ToString();
                this.mRazonSocial = dtInfo.Rows[0]["RAZON_SOCIAL"].ToString();
                this.mTipoAcuerdo = dtInfo.Rows[0]["TIPODESC"].ToString();
                this.mFechaReg = string.Format("{0:d}",dtInfo.Rows[0]["FECHA_REGISTRO"]).ToString();
                this.mFechaTerm = string.Format("{0:d}",dtInfo.Rows[0]["FECHA_TERMINO"]).ToString();
                this.mTipoDocumento = dtInfo.Rows[0]["TIPO_DOCUMENTO"].ToString();
                this.mNoDocumento = dtInfo.Rows[0]["NO_DOCUMENTO"].ToString();
                this.mStatus = dtInfo.Rows[0]["STATUSDESC"].ToString();
                this.mEstadoCivil = dtInfo.Rows[0]["ESTADO_CIVIL"].ToString();
                this.mDireccion = dtInfo.Rows[0]["DIRECCION"].ToString();
                this.mProvincia = dtInfo.Rows[0]["provincia_des"].ToString();
                this.mNacionalidad = dtInfo.Rows[0]["ID_NACIONALIDAD"].ToString();
                this.mPeriodoIni = dtInfo.Rows[0]["PERIODO_INI"].ToString();
                this.mPeriodoFin = dtInfo.Rows[0]["PERIODO_FIN"].ToString();
                this.mTelefono1 = dtInfo.Rows[0]["telefono_1"].ToString();
                this.mTelefono2 = dtInfo.Rows[0]["telefono_2"].ToString();
                this.mRegPatronal = dtInfo.Rows[0]["ID_REGISTRO_PATRONAL"].ToString();
                this.mCargo = dtInfo.Rows[0]["CARGO"].ToString();
                this.mCuotas = dtInfo.Rows[0]["CUOTAS"].ToString();
            }

            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static string ValidateTipoAcuerdo(string Acuerdo)
        {
            try
            {
                if (Acuerdo.ToUpper().Contains("AO-") )
                {
                    //Se devuelve el # del acuerdo y el tipo ordinario
                    return Acuerdo.Remove(0, 3) + "|" + 3;

                }
                //Se devuelve el # del acuerdo y el tipo Embajadas.
                else if  (Acuerdo.ToUpper().Contains("AE-"))
                {
                    return Acuerdo.Remove(0, 3) + "|" + 4;
                }
                else
                {
                    //Se devuelve el # del acuerdo y el tipo Ley189
                    return Acuerdo + "|" + 2;
                }
            }
            catch 
            {
                return 0 + "|" + 0;
            }
        }

        public override String GuardarCambios(string UsuarioResponsable)
        {
            return "";

            //OracleParameter[] orParam = new OracleParameter[7];

            //orParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            //orParam[0].Value = this.RegistroPatronal;
            //orParam[1] = new OracleParameter("p_id_nomina", OracleDbType.Decimal);
            //orParam[1].Value = this.IDNomina;
            //orParam[2] = new OracleParameter("p_nomina_des", OracleDbType.NVarchar2);
            //orParam[2].Value = this.NominaDes;
            //orParam[3] = new OracleParameter("p_status", OracleDbType.NVarchar2);
            //orParam[3].Value = this.Estatus;
            //orParam[4] = new OracleParameter("p_tipo_nomina", OracleDbType.NVarchar2);
            //orParam[4].Value = this.TipoNomina;
            //orParam[5] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2);
            //orParam[5].Value = UsuarioResponsable;
            //orParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            //orParam[6].Direction = ParameterDirection.Output;


            //try
            //{
            //    SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sre_nominas_pkg.nominas_editar", orParam);
            //    return orParam[6].Value.ToString();
            //}

            //catch (Exception ex)
            //{
            //    return ex.ToString();
            //}
        }

        public static DataTable getAcuerdosPagoTipo(string Tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[3];
            arrParam[0] = new OracleParameter("p_tipo", OracleDbType.Char);
            arrParam[0].Value = Tipo;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getAcuerdosPago";

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

        public static DataTable getDetAcuerdoPago(int idAcuerdo, eTiposAcuerdos tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_idAcuerdo ", OracleDbType.Int32);
            arrParam[0].Value = idAcuerdo;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getDetAcuerdoPago";

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

        public static DataTable getDetAcuerdoPagoFechaLimite(int idAcuerdo, eTiposAcuerdos tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_idAcuerdo ", OracleDbType.Int32);
            arrParam[0].Value = idAcuerdo;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getFechaLimiteCuotaAcuerdoPago";

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

        public static DataTable getAcuerdosVencidos()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getAcuerdosVencidos";

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

        public static DataTable getDetAcuerdoVencido(int idAcuerdo, eTiposAcuerdos tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_idAcuerdo ", OracleDbType.Int32);
            arrParam[0].Value = idAcuerdo;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getDetAcuerdoVencido";

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

        public static string cambiarStatusAcuerdoPago(int idAcuerdo, eTiposAcuerdos tipo, int status, string regPatronal, string asunto, int tipoRegistro, string comentario, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_idAcuerdo", OracleDbType.Int32);
            arrParam[0].Value = idAcuerdo;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_status", OracleDbType.Int32);
            arrParam[2].Value = status;
            arrParam[3] = new OracleParameter("p_registro_patronal", OracleDbType.NVarchar2);
            arrParam[3].Value = regPatronal;
            arrParam[4] = new OracleParameter("p_asunto", OracleDbType.Varchar2, 100);
            arrParam[4].Value = asunto;
            arrParam[5] = new OracleParameter("p_tipo_registro", OracleDbType.Decimal);
            arrParam[5].Value = tipoRegistro;
            arrParam[6] = new OracleParameter("p_registro_des", OracleDbType.Varchar2, 1000);
            arrParam[6].Value = comentario;
            arrParam[7] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 35);
            arrParam[7].Value = usuario;
            arrParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[8].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.editAcuerdoPago";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[8].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        public static string CrearAcuerdoPago(int regPatronal, eTiposAcuerdos tipo, structDatosContrato InfoAcuerdo, string usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[13];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_nombres", OracleDbType.Varchar2, 200);
            arrParam[2].Value = InfoAcuerdo.NombreRepresentante;
            arrParam[3] = new OracleParameter("p_no_documento", OracleDbType.Varchar2, 11);
            arrParam[3].Value = InfoAcuerdo.NroCedulaoPasaporte;
            arrParam[4] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2, 1);
            arrParam[4].Value = InfoAcuerdo.TipoDocumentoRepresentante;
            arrParam[5] = new OracleParameter("p_cargo", OracleDbType.Varchar2, 200);
            arrParam[5].Value = InfoAcuerdo.CargoRepresentante;
            arrParam[6] = new OracleParameter("p_direccion", OracleDbType.Varchar2, 350);
            arrParam[6].Value = InfoAcuerdo.Direccion;
            arrParam[7] = new OracleParameter("p_id_nacionalidad", OracleDbType.Varchar2, 40);
            arrParam[7].Value = InfoAcuerdo.Nacionalidad;
            arrParam[8] = new OracleParameter("p_estado_civil", OracleDbType.Varchar2, 1);
            arrParam[8].Value = InfoAcuerdo.EstadoCivil;
            arrParam[9] = new OracleParameter("p_periodo_ini", OracleDbType.NVarchar2);
            arrParam[9].Value = InfoAcuerdo.PeriodoIni;
            arrParam[10] = new OracleParameter("p_periodo_fin", OracleDbType.NVarchar2);
            arrParam[10].Value = InfoAcuerdo.PeriodoFin;
            arrParam[11] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 35);
            arrParam[11].Value = usuario;
            arrParam[12] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[12].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.crearAcuerdoPago";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[12].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        public static string CrearCuota(string idAcuerdoPago, eTiposAcuerdos tipo, int nroCuota, string nroReferencia)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_acuerdo", OracleDbType.Decimal);
            arrParam[0].Value = idAcuerdoPago;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_cuota", OracleDbType.Decimal);
            arrParam[2].Value = nroCuota;
            arrParam[3] = new OracleParameter("p_id_referencia", OracleDbType.Varchar2, 16);
            arrParam[3].Value = nroReferencia;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.crearDetAcuerdoPago";

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

        /// <summary>
        /// Metodo utilizado para setear las fechas límite de pago en cada referencia de un acuerdo de pago especifico.
        /// </summary>
        /// <param name="idAcuerdoPago">Nro. de acuerdo de pago del empleador.</param>
        /// <returns>resultnumber</returns>
        /// <remarks>By Charlie L. Peña</remarks>
        public static string setFechasLimitesPago(int idAcuerdoPago, eTiposAcuerdos tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_acuerdo", OracleDbType.Decimal);
            arrParam[0].Value = idAcuerdoPago;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.setFechasLimitesPago";

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

        public static string SubirImagenAcuerdoPago(string idAcuerdoPago, eTiposAcuerdos tipo, Byte[] imageFile, string idUsuario)

        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_Acuerdo", OracleDbType.NVarchar2);
            arrParam[0].Value = idAcuerdoPago;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_imagen", OracleDbType.Blob);
            arrParam[2].Value = imageFile;
            arrParam[3] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 35);
            arrParam[3].Value = idUsuario;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.subirImagenAcuerdoPago";

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

        public static DataTable getFechasLimitePago(int CantidadCuotas)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_cuotas", OracleDbType.Int32);
            arrParam[0].Value = CantidadCuotas;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "LGL_LEGAL_PKG.getFechasLimitesPago";

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
        /// Metodo utilizado para obtener las notificaciones que se le han hecho a un empleador.
        /// </summary>
        /// <param name="idRegPatronal">registro patronal del empleador.</param>
        /// <returns>Un datatable con las notificaciones realizadas</returns>
        /// <remarks>By Ronny Carreras</remarks>
        public static DataTable getNotificacionesPorEmpleador(int idRegPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegPatronal;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "LGL_LEGAL_PKG.getNotificacionesPorEmpleador";

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
        /// Metodo utilizado para obtener los acuerdos que ha realizado un empleador.
        /// </summary>
        /// <param name="idRegPatronal">Registro Patronal del empleador.</param>
        /// <returns>Un Datatable con la informacion indicada.</returns>
        /// <remarks>By Ronny Carreras</remarks>
        public static DataTable getAcuerdosPorEmpleador(eTiposAcuerdos tipo, int idRegPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegPatronal;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[2].Value = tipo;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "LGL_LEGAL_PKG.getAcuerdosPorEmpleador";

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

        public static DataTable getAcuerdosPorEmpleador(int? idRegPatronal, int? idAcuerdo,eTiposAcuerdos? tipo)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            if (idRegPatronal.HasValue)
            {
                arrParam[0].Value = idRegPatronal.Value;
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }

            arrParam[1] = new OracleParameter("p_id_acuerdo", OracleDbType.Int32);
            if (idAcuerdo.HasValue)
            {
                arrParam[1].Value = idAcuerdo.Value;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }


            arrParam[2] = new OracleParameter("p_tipo", OracleDbType.Int32);
            if (tipo.HasValue)
            {
                arrParam[2].Value = tipo.Value;
            }
            else
            {
                arrParam[2].Value = DBNull.Value;
            }

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            string cmdStr = "LGL_LEGAL_PKG.getAcuerdosPorEmpleador";

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
        /// Metodo utilizado para obtener la imagen del acuerdo de pago realizado a un empleador.
        /// </summary>
        /// <param name="pidAcuerdo">Nro. acuerdo de pago del empleador</param>
        /// <returns>Un Byte[] con la informacion indicada.</returns>
        /// <remarks>By Charlie L. Peña</remarks>
        public static Byte[] getImagenAcuerdoPago(int idAcuerdo, eTiposAcuerdos tipo)
        {
            byte[] img = null;
            OracleDataReader odr = null;
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_idAcuerdo", OracleDbType.Int32);
            arrParam[0].Value = idAcuerdo;

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getImagenAcuerdoPago";

            try
            {
                odr = DataBase.OracleHelper.ExecuteDataReader(CommandType.StoredProcedure, cmdStr, arrParam);
                if (odr.HasRows)
                { 
                    odr.Read();
                    if (!odr.IsDBNull(0))
                    { 
                        img = new byte[(odr.GetBytes(0,0,null,0,int.MaxValue))];
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

        public static DataTable getAcuerdosPago(int? idAcuerdo,eTiposAcuerdos? tipo, int? idRegPat, string razon_social, string fecha_desde, string fecha_hasta, int? status)
        {

            string result = string.Empty;
            string resultado = string.Empty;
            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_idacuerdo", OracleDbType.Int32);
            if (idAcuerdo.HasValue)
            {
                arrParam[0].Value = idAcuerdo.Value;
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            if (tipo.HasValue)
            {
                arrParam[1].Value = tipo.Value;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }

            arrParam[2] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            if (idRegPat.HasValue)
            {
                arrParam[2].Value = idRegPat.Value;
            }
            else
            {
                arrParam[2].Value = DBNull.Value;
            }

            arrParam[3] = new OracleParameter("p_razon_social", OracleDbType.Varchar2, 150);
            arrParam[3].Value = razon_social;

            arrParam[4] = new OracleParameter("p_fecha_desde", OracleDbType.Varchar2, 10);
            arrParam[4].Value = fecha_desde;

            arrParam[5] = new OracleParameter("p_fecha_hasta", OracleDbType.Varchar2, 10);
            arrParam[5].Value = fecha_hasta;

            arrParam[6] = new OracleParameter("p_status", OracleDbType.Int32);
            if (status.HasValue)
            {
                arrParam[6].Value = status.Value;
            }
            else
            {
                arrParam[6].Value = DBNull.Value;
            }

            arrParam[7] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[7].Direction = ParameterDirection.Output;

            arrParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[8].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getAcuerdosPago";

            try
            {
                //return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[8].Value.ToString() != "0")
                { 
                    result = arrParam[8].Value.ToString();
                    resultado = result.Split('|')[1].ToString();
                    throw new Exception(resultado);
                }
                return ds.Tables[0];

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }

        }

        public static DataTable getAcuerdosPago(int idRegPat, int tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegPat;

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getAcuerdosPago";

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

        public DataTable getFechaLimiteCuotaAcuerdoPago(int idAcuerdo, eTiposAcuerdos tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_idacuerdo", OracleDbType.Int32);
            arrParam[0].Value = idAcuerdo;

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "LGL_LEGAL_PKG.getFechaLimiteCuotaAcuerdoPago", arrParam);
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
        
        public static DataTable getStatusAcuerdo()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

           
            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getStatusAcuerdo";

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

        public  string EditarAcuerdoPago(string usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[12];

            arrParam[0] = new OracleParameter("p_id_acuerdo", OracleDbType.Int16);
            arrParam[0].Value = this.mIdAcuerdo;

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int16);
            arrParam[1].Value = this.mTipo;

            arrParam[2] = new OracleParameter("p_cargo", OracleDbType.Varchar2, 120);
            arrParam[2].Value = this.mCargo;

            arrParam[3] = new OracleParameter("p_direccion", OracleDbType.Varchar2, 200);
            arrParam[3].Value = this.mDireccion;

            arrParam[4] = new OracleParameter("p_estado_civil", OracleDbType.Varchar2, 1);
            arrParam[4].Value = this.mEstadoCivil;

            arrParam[5] = new OracleParameter("p_id_nacionalidad", OracleDbType.Varchar2, 40);
            arrParam[5].Value = this.mNacionalidad;

            arrParam[6] = new OracleParameter("p_nombres", OracleDbType.Varchar2, 120);
            arrParam[6].Value = this.mNombres;

            arrParam[7] = new OracleParameter("p_no_documento", OracleDbType.Varchar2, 25);
            arrParam[7].Value = this.mNoDocumento;

            arrParam[8] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2, 1);
            arrParam[8].Value = this.mTipoDocumento;

            arrParam[9] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 35);
            arrParam[9].Value = usuario;

            arrParam[10] = new OracleParameter("p_reg_pat", OracleDbType.Int32);
            arrParam[10].Value = this.RegPatronal;
            
            arrParam[11] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[11].Direction = ParameterDirection.Output;

  
            String cmdStr = "LGL_LEGAL_PKG.EditarAcuerdoPago";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[11].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        public static DataTable getCuotasAcuerdoPago(int idAcuerdo, eTiposAcuerdos tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_id_Acuerdo ", OracleDbType.Int32);
            arrParam[0].Value = idAcuerdo;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getCuotasAcuerdo";

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

        public static DataTable getPasosAcuerdoPago(int idAcuerdo, eTiposAcuerdos tipo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_id_Acuerdo ", OracleDbType.Int32);
            arrParam[0].Value = idAcuerdo;
            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int32);
            arrParam[1].Value = tipo;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getPasosAcuerdo";

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
        
        //Milciades Hernandez
        //04/06/2010
        public static DataTable getSeguimientoAcuerdosPagos()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.AcuerdosPagoVencidos";

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

        public static string CancelarAPincumplido(int idAcuerdo, int tipo, string usuarioModifica)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_acuerdo", OracleDbType.Int16);
            arrParam[0].Value = idAcuerdo;

            arrParam[1] = new OracleParameter("p_tipo", OracleDbType.Int16);
            arrParam[1].Value = tipo;

            arrParam[2] = new OracleParameter("p_Usuario", OracleDbType.Varchar2, 120);
            arrParam[2].Value = usuarioModifica;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;


            String cmdStr = "LGL_LEGAL_PKG.CancelarAPincumplido";

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

        public static DataTable getResumenPago(int p_periodo_desde, int p_periodo_hasta)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_periodo_desde", OracleDbType.Int32);
            arrParam[0].Value = p_periodo_desde;
            arrParam[1] = new OracleParameter("p_periodo_hasta", OracleDbType.Int32);
            arrParam[1].Value = p_periodo_hasta;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "lgl_legal_pkg.getresumenpago";

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
    }
}
