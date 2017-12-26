using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlus.Empresas.Facturacion
{
    /// <summary>
    /// Clase para manejar las planillas del ministerio de trabajo.
    /// </summary>
    public class PlanillaMDT : Factura
    {
        /// <summary>
        /// Variables utilizadas para la facturacion por PIN del ministerio de trabajo
        /// </summary>
        //internal Int32 myNroReciboPIN;
        //internal decimal myMontoPIN;
        //internal decimal myBalancePIN;
        //internal string myStatusPIN;


        public PlanillaMDT(string NroReferencia)
        {
            this.myConcepto = Factura.eConcepto.MDT;
            this.myInstitucion = Factura.eInstitucion.MDT;
            this.myNroReferencia = NroReferencia;
            this.CargarDatos();
        }

        public PlanillaMDT(Int64 NroAutorizacion)
        {    this.myConcepto = Factura.eConcepto.MDT;
            this.myInstitucion = Factura.eInstitucion.MDT;
            this.myNroAutorizacion = NroAutorizacion;
            this.CargarDatos();
        }

        internal decimal myTotalSalariosBonificacion;

        /// <summary>
        /// La sumatoria de los Salarios de los Trabajadores. 
        /// En caso de que sea una factura de bonificación seria la sumatoria de las bonificaciones
        /// </summary>
        public decimal TotalSalariosBonificacion
        {
            get { return this.myTotalSalariosBonificacion; }
        }

        public override void CargarDatos()
        {
            DataTable dt = new DataTable();
            string resultado = string.Empty;
            string res = string.Empty;
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_NoReferencia", OracleDbType.NVarchar2, 16);
            arrParam[0].Value = this.myNroReferencia;

            arrParam[1] = new OracleParameter("p_NoAutorizacion", OracleDbType.Decimal);
            arrParam[1].Value = this.myNroAutorizacion;

            arrParam[2] = new OracleParameter("p_concepto", OracleDbType.NVarchar2, 4);
            arrParam[2].Value = this.myConcepto;

            arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            try
            {

                //dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_FACTURA_PKG.Cargar_Datos", arrParam).Tables[0];
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_FACTURA_PKG.Cargar_Datos", arrParam);
                if (ds.Tables.Count > 0)
                //if (dt.Rows.Count > 0)
                {
                    dt = ds.Tables[0];

                    this.myIdPlanilla = dt.Rows[0]["id_planilla"].ToString();
                    this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                    this.myRegistroPatronal = Convert.ToInt32(dt.Rows[0]["id_registro_patronal"].ToString());
                    this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
                    this.myNomina = "MDT";
                    this.myTipoFactura = dt.Rows[0]["tipo_factura_des"].ToString();
                    this.myEstatus = dt.Rows[0]["status"].ToString();
                    this.myTipo = dt.Rows[0]["id_tipo_factura"].ToString();
                    this.myNroReferencia = dt.Rows[0]["id_referencia_planilla"].ToString();
                    this.myFechaAutorizacion = dt.Rows[0]["fecha_autorizacion"].ToString();
                    this.myFechaDesAutorizacion = dt.Rows[0]["fecha_desautorizacion"].ToString();
                    this.myFechaEmision = Convert.ToDateTime(dt.Rows[0]["fecha_emision"]);
                    this.myFechaReportePago = (dt.Rows[0]["fecha_reporte_pago"] != System.DBNull.Value ? Convert.ToDateTime(dt.Rows[0]["fecha_reporte_pago"]) : new DateTime());
                    this.myFechaReporte = dt.Rows[0]["fecha_reporte_pago"].ToString();
                    this.myFechaLimitePago = Convert.ToDateTime(dt.Rows[0]["fecha_limite_pago"]);
                    this.myNroAutorizacion = (dt.Rows[0]["no_autorizacion"] != System.DBNull.Value ? Convert.ToInt64(dt.Rows[0]["no_autorizacion"].ToString()) : 0);
                    this.myTotalAsalariados = Convert.ToInt32(dt.Rows[0]["total_trabajadores"].ToString());
                    this.myTotalLocalidades = Convert.ToInt32(dt.Rows[0]["total_localidades"].ToString());
                    this.myTotalSalariosBonificacion = Convert.ToDecimal(dt.Rows[0]["total_salario"].ToString());
                    this.myTotalGeneral = Convert.ToDecimal(dt.Rows[0]["total_pago"].ToString());
                    this.myUsuarioDesAutorizo = dt.Rows[0]["id_usuario_desautoriza"].ToString();
                    this.myUsuarioAutorizo = dt.Rows[0]["id_usuario_autoriza"].ToString();
                    this.myFechaPago = dt.Rows[0]["fecha_pago"].ToString();
                    this.myObservacion = dt.Rows[0]["observacion"].ToString();
                    this.myEntidadRecaudadora = dt.Rows[0]["entidad_recaudadora_des"].ToString();
                    this.myPeriodo = dt.Rows[0]["periodo_factura"].ToString();
                    this.myOrigenPago = dt.Rows[0]["OrigenPago"].ToString();
                }
                else
                {
                    resultado = "1|No Existen Registros Para Este No. Referencia/Autorización.";
                    throw new Exception(resultado);
                }

                //dt.Dispose();
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
                if (resultado == string.Empty)
                {
                    resultado = arrParam[4].Value.ToString();
                }
                res = resultado.Split('|')[1].ToString();
                throw new Exception(res);

            }
        }
        
        public static DataTable ListarPIN(int id_registro_patronal)
        {
             //DataSet ds = new DataSet;
             String cmdStr = "SRE_MDT_PKG.listarPin";

             //Definimos nuestro arreglo de parametros.
             OracleParameter[] arrParam = new OracleParameter[3];

             arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
             arrParam[0].Value = id_registro_patronal;

             arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[1].Direction = ParameterDirection.Output;

             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[2].Direction = ParameterDirection.Output;

             try
             {

                 string result = string.Empty;

                 //Ejecuamos el commando.
                 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                 if (ds.Tables[0].Rows.Count > 0)
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
                
        public override String GuardarCambios(string UsuarioResponsable)
        {
            return "";
        }

        /// <summary>
        /// Function utilizada para indicar si existe una factura de bonificacion pagada o autorizada
        /// para un rnc y periodo en especifico.
        /// </summary>
        /// <param name="rnc">El rnc del empleador.</param>
        /// <param name="periodo">El periodo de la factura de bonificacion</param>
        /// <returns>True o False dependiendo si exite la factura</returns>
        public static bool existeFacturaBonosPagada(string rnc, string periodo)
        {

            //Convertimos el periodo en formato YYYYMM
            periodo = periodo.Substring(2, 4).ToString() + periodo.Substring(0, 2).ToString();

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_periodo", OracleDbType.Decimal);
            arrParam[1].Value = periodo;

            arrParam[2] = new OracleParameter("p_result", OracleDbType.Char, 1);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sfc_infotep_pkg.ExisteFactBonificacion";
            bool existe = false;
            string resultado = null;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                resultado = arrParam[2].Value.ToString();
                if (resultado == "S")
                    existe = true;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return existe;

        }
    }
}
