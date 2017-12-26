using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Empresas
{
    public class CuentaBancaria: FrameWork.Objetos
    {
        #region Properties
        private int registroPatronal;
        public int RegistroPatronal
        {
            get { return registroPatronal; }
            set { registroPatronal = value; }
        }
        private string rNC;
        public string RNC
        {
            get { return rNC; }
            set { rNC = value; }
        }
        private string razonSocial;
        public string RazonSocial
        {
            get { return razonSocial; }
            set { razonSocial = value; }
        }
        private string idEntidadRecaudadora;
        public string IdEntidadRecaudadora
        {
            get { return idEntidadRecaudadora; }
            set { idEntidadRecaudadora = value; }
        }
        private string nroCuenta;
        public string NroCuenta
        {
            get { return nroCuenta; }
            set { nroCuenta = value; }
        }
        private string tipoCuenta;
        public string TipoCuenta
        {
            get { return tipoCuenta; }
            set { tipoCuenta = value; }
        }
        private string rNCoCedulaDuenoCuenta;
        /// <summary>
        /// RNC o la Cedula del dueño de la cuenta
        /// </summary>
        public string RNCoCedulaDuenoCuenta
        {
            get { return rNCoCedulaDuenoCuenta; }
            set { rNCoCedulaDuenoCuenta = value; }
        }
#endregion

        #region "Metodos de la clase"
        public CuentaBancaria(int RegistroPatronal)
        {
            this.registroPatronal = RegistroPatronal;
            this.CargarDatos();
        }

        public CuentaBancaria(string RNC)
        {
            this.rNC = RNC;
            this.CargarDatos();
        }

        public CuentaBancaria()
        {
        }

        /// <summary>
        /// Trae el historial de las cuentas almacenadas en la tabla sfs_historico_cuentas_t
        /// </summary>
        public void getHistorialCuentas()
        {

        }

        public override void CargarDatos()
        {
            //Cargar calores de propiedades cuenta bancaria
            DataTable dtCuenta = GetCuenta(RegistroPatronal, RNC);
            try
            {
                if (dtCuenta.Rows.Count > 0)
                {
                    this.IdEntidadRecaudadora = dtCuenta.Rows[0]["EntidadRecaudadora"].ToString();
                    this.NroCuenta = dtCuenta.Rows[0]["NroCuenta"].ToString();
                    this.RNCoCedulaDuenoCuenta = dtCuenta.Rows[0]["RNCoCedulaDuenoCuenta"].ToString();
                    this.RNC = dtCuenta.Rows[0]["RNC"].ToString();
                    this.RegistroPatronal = Convert.ToInt32(dtCuenta.Rows[0]["RegistroPatronal"]);
                    this.RazonSocial = dtCuenta.Rows[0]["RazonSocial"].ToString();
                    this.TipoCuenta = dtCuenta.Rows[0]["TipoCuenta"].ToString();
                }
                else
                {

                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public override string GuardarCambios(string usuarioResponsable)
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Int32);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.IdEntidadRecaudadora);

            arrParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2, 11);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.RNCoCedulaDuenoCuenta);

            arrParam[2] = new OracleParameter("p_cuenta_bancaria", OracleDbType.Varchar2, 25);
            arrParam[2].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.NroCuenta);

            arrParam[3] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[3].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.RegistroPatronal);

            arrParam[4] = new OracleParameter("p_tipo_cuenta", OracleDbType.Int32);
            arrParam[4].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.TipoCuenta);

            arrParam[5] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 35);
            arrParam[5].Value = SuirPlus.Utilitarios.Utils.verificarNulo(usuarioResponsable);

            arrParam[6] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.InputOutput;

            String cmdStr = "sre_empleadores_pkg.Actualizar_Cuenta_Bancaria";

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

        public static DataTable GetCuenta(int registroPatronal, string rNC)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(registroPatronal);

            arrParam[1] = new OracleParameter("p_razon_Social", OracleDbType.Varchar2, 150);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(rNC);

            arrParam[2] = new OracleParameter("cuentas_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.InputOutput;

            String cmdStr = "sre_empleadores_pkg.get_cuenta_bancaria";

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

        public static DataTable GetHistoricoCuentas(int registroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(registroPatronal);

            arrParam[1] = new OracleParameter("historico_cuentas_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.InputOutput;

            String cmdStr = "sre_empleadores_pkg.Get_Historico_Cuentas";

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
