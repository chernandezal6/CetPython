using System;
using SuirPlus;
using SuirPlus.DataBase;
using SuirPlus.Empresas;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.Utilitarios;
using SuirPlus.Exepciones;
namespace SuirPlus.Subsidios
{
    public class CuentaBancariaMadre : abstractNovedad 
    {
        #region Propiedades de la Clase
        /// <summary>
        /// Cuenta del banco
        /// </summary>
        public String CuentaBanco { get; set; }
        
        /// <summary>
        /// Registro Patronal
        /// </summary>
        public Int32 RegistroPatronal { get; set; }

        /// <summary>
        /// RNC
        /// </summary>
        public String RNC { get; set; }

        /// <summary>
        /// Razon Social
        /// </summary>
        public string RazonSocial { get; set; }

        /// <summary>
        /// Tipo de cuenta
        /// </summary>
        public String TipoCuenta { get; set; }
        /// <summary>
        /// Nro. de documento de la persona aquien corresponde la cuenta
        /// </summary>
        public String NroDocumento { get; set; }
                
        public Int32 IdEntidadRecaudadora { get; set; }

        public String EntidadRecaudadora { get; set; }

        #endregion

        #region "Metodos publicos de la clase"

        public CuentaBancariaMadre()
        {
           
        }


        public static String actualizarCuentaBancaria(CuentaBancariaMadre cuentabancaria) 
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Int32);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(cuentabancaria.IdEntidadRecaudadora);

            arrParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2, 11);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(cuentabancaria.NroDocumento);

            arrParam[2] = new OracleParameter("p_cuenta_bancaria", OracleDbType.Varchar2, 25);
            arrParam[2].Value = SuirPlus.Utilitarios.Utils.verificarNulo(cuentabancaria.CuentaBanco);

            arrParam[3] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[3].Value = SuirPlus.Utilitarios.Utils.verificarNulo(cuentabancaria.RegistroPatronal);

            arrParam[4] = new OracleParameter("p_tipo_cuenta", OracleDbType.Int32);
            arrParam[4].Value = SuirPlus.Utilitarios.Utils.verificarNulo(cuentabancaria.TipoCuenta);

            arrParam[5] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 35);
            arrParam[5].Value = SuirPlus.Utilitarios.Utils.verificarNulo(cuentabancaria.UltimoUsrAct);

            arrParam[6] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.InputOutput;

            String cmdStr = "sre_empleadores_pkg.Actualizar_Cuenta_Bancaria";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return SuirPlus.Utilitarios.Utils.sacarMensajeDeError(arrParam[6].Value.ToString());
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }


        //public override string GuardarCambios(string UsuarioResponsable)
        //{
        //    OracleParameter[] arrParam = new OracleParameter[7];

        //    arrParam[0] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Int32);
        //    arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.EntidadRecaudadora);

        //    arrParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2, 11);
        //    arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.NroDocumento);

        //    arrParam[2] = new OracleParameter("p_cuenta_bancaria", OracleDbType.Varchar2, 25);
        //    arrParam[2].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.CuentaBanco);

        //    arrParam[3] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
        //    arrParam[3].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.RegistroPatronal);

        //    arrParam[4] = new OracleParameter("p_tipo_cuenta", OracleDbType.Int32);
        //    arrParam[4].Value = SuirPlus.Utilitarios.Utils.verificarNulo(this.TipoCuenta);

        //    arrParam[5] = new OracleParameter("p_usuario", OracleDbType.Varchar2, 35);
        //    arrParam[5].Value = SuirPlus.Utilitarios.Utils.verificarNulo(UsuarioResponsable);

        //    arrParam[6] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
        //    arrParam[6].Direction = ParameterDirection.InputOutput;

        //    String cmdStr = "sre_empleadores_pkg.Actualizar_Cuenta_Bancaria";

        //    try
        //    {
        //        DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
        //        return arrParam[6].Value.ToString();
        //    }
        //    catch (Exception ex)
        //    {
        //        Exepciones.Log.LogToDB(ex.ToString());
        //        throw ex;
        //    }
        //}
        #endregion

        #region "Funciones estaticas de la clase"
     
        public static CuentaBancariaMadre getDetalleCuenta(Int32 registroPatronal, String RNC) 
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = Utils.verificarNulo(registroPatronal);

            arrParam[1] = new OracleParameter("p_razon_Social", OracleDbType.Varchar2, 150);
            arrParam[1].Value = Utils.verificarNulo(RNC);

            arrParam[2] = new OracleParameter("cuentas_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.InputOutput;

 
            try
            {
                var cuenta = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "sre_empleadores_pkg.get_cuenta_bancaria", arrParam).Tables[0];

                var Detallecuenta = new CuentaBancariaMadre();

                Detallecuenta.RegistroPatronal = cuenta.Rows[0].Field<Int32>("RegistroPatronal"); 
                Detallecuenta.RazonSocial = cuenta.Rows[0].Field<String>("RazonSocial"); 
                Detallecuenta.EntidadRecaudadora = cuenta.Rows[0].Field<String>("EntidadRecaudadora");
                Detallecuenta.CuentaBanco = cuenta.Rows[0].Field<String>("NroCuenta");
                Detallecuenta.RNC = cuenta.Rows[0].Field<String>("RNC");
                Detallecuenta.TipoCuenta = cuenta.Rows[0].Field<String>("TipoCuenta");

                return Detallecuenta;

             
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
