using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using SuirPlus;
using SuirPlus.Exepciones;
using SuirPlus.DataBase;
using SuirPlus.FrameWork;
using Oracle.ManagedDataAccess.Client;
namespace SuirPlus.Operaciones
{
    public class ConsultasJCE : Objetos
    {
   
        #region "Contructor de la Clase"
        public ConsultasJCE() { }
        #endregion

        #region "Metodos de la Clase SuirPlus.Consultas JCE"

        // Milciades Hernandez  8/01/2014//
        //public static void gettranslimite(string statuscode, string reason_phrase, string nrodocumento , string tipodocumento )
        public static void gettranslimite(string nrodocumento, string tipodocumento)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            //arrParam[0] = new OracleParameter("P_status_code", OracleDbType.NVarchar2, 20);
            //arrParam[0].Value = statuscode;

            //arrParam[1] = new OracleParameter("P_reason_phrase", OracleDbType.NVarchar2, 50);
            //arrParam[1].Value = reason_phrase;

            arrParam[0] = new OracleParameter("p_nro_documento", OracleDbType.NVarchar2, 25);
            arrParam[0].Value = nrodocumento;

            arrParam[1] = new OracleParameter("p_tipo_documento", OracleDbType.NVarchar2, 10);
            arrParam[1].Value = tipodocumento;


            //String cmdStr = "SRP_JCE_PKG.prc_trans_limite";
            String cmdStr = "Sre_Ciudadano_Pkg.prc_trans_limite";

            try
            {
              DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;
            }
        }

     
        #endregion


        public override void CargarDatos()
        {
            throw new NotImplementedException();
        }

        public override string GuardarCambios(string UsuarioResponsable)
        {
            throw new NotImplementedException();
        }
    }
}
