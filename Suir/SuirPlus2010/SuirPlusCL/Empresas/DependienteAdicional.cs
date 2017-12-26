using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Empresas
{
    public class DependienteAdicional
    {

        private DependienteAdicional()
        {
            //No es necesario hacer una instancia de esta clase.
		}

            // Consulta de dependiente
		public static DataTable getDependienteAdicional(string Cedula, string Idnss)
		{

			OracleParameter[] arrParam  = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.NVarchar2, 20);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Idnss);
            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 20);
			arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Cedula);
			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;

			String cmdStr= "SRE_TRABAJADOR_PKG.Get_DependienteAdicional";
			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

		// Consulta el titular del dependiente
		public static DataTable getTitular(string Cedula, string Idnss)
		{

			OracleParameter[] arrParam  = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.NVarchar2, 20);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Idnss);
            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 20);
			arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Cedula);
			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;
		
			String cmdStr= "SRE_TRABAJADOR_PKG.Get_Titular";
			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}
		}

        //Detalle de Notificaciones de Pago
        //Periodo, NroReferencia, Status (de la Referencia), FechaPago (de la Referencia)
        public static DataTable getRefByDepAdicional(string Cedula, string Idnss, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_NoDocumento", OracleDbType.Varchar2, 25);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Cedula);
            arrParam[1] = new OracleParameter("p_IdNss", OracleDbType.Int32, 10);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Idnss);
            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[2].Value = pagenum;
            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[3].Value = pagesize;
            arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ars_pkg.getPage_RefByDepAdicional";
            string Resultado = string.Empty;
            string res = string.Empty;
            try
              {
                  DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                  Resultado = arrParam[5].Value.ToString();

                  if (Resultado != "0")
                  {
                      res = Resultado.Split('|')[1].ToString();
                      throw new Exception(res);
                  }

                  return ds.Tables[0];
              }
              catch (Exception ex)
              {
                  throw new Exception(ex.Message);
              }

        }

        //Detalle de las notificaciones de pago apra un dependiente Adicional de un titular dado.
        //Metodo Get_NotificacionesPagadas. Devuelve #referencia, periodo factura,monto pagado, rnc empleador y razon social.
        public static DataTable getNotificacionesPagadasByDepAdicional(string Cedula_titular, string Cedula_dependiente,string rnc, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_cedula_titular", OracleDbType.Varchar2, 25);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Cedula_titular);
            arrParam[1] = new OracleParameter("p_cedula_dependiente", OracleDbType.Varchar2, 25);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Cedula_dependiente);
            arrParam[2] = new OracleParameter("p_rnc", OracleDbType.Varchar2, 11);
            arrParam[2].Value = SuirPlus.Utilitarios.Utils.verificarNulo(rnc);
            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[3].Value = pagenum;
            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[4].Value = pagesize;
            arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;
            arrParam[6] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "sre_trabajador_pkg.Get_NotificacionesPagadas";
            string Resultado = string.Empty;
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[6].Value.ToString();

                if (Resultado != "0")
                {
                    res = Resultado.Split('|')[1].ToString();
                    throw new Exception(res);
                }
                else
                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

        }
        //Detalle de Cartera & Dispersion
        //Periodo, Dispersado (Si/No), Fecha Registro Cartera, Fecha Registro Dispersion

        public static DataTable getCarteraDispersion(string Cedula, string Idnss, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_NoDocumento", OracleDbType.Varchar2, 25);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Cedula);
            arrParam[1] = new OracleParameter("p_IdNss", OracleDbType.Int32, 10);
            arrParam[1].Value = SuirPlus.Utilitarios.Utils.verificarNulo(Idnss);
            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[2].Value = pagenum;
            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[3].Value = pagesize;
            arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "sre_ars_pkg.getPage_CarteraDispersion";
            string Resultado = string.Empty;
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[5].Value.ToString();

                if (Resultado != "0")
                {
                    res = Resultado.Split('|')[1].ToString();
                    throw new Exception(res);
                }

                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

        }


        public static DataTable getPageDepFonamat(string rnc, int pagenum, int pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.Varchar2, 11);
            arrParam[0].Value = SuirPlus.Utilitarios.Utils.verificarNulo(rnc);
            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Double);
            arrParam[1].Value = pagenum;
            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Double);
            arrParam[2].Value = pagesize;
            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_resultNumber", OracleDbType.NVarchar2, 1000);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_TRABAJADOR_PKG.GetPage_DepFonamat";
            string Resultado = string.Empty;
            string res = string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[4].Value.ToString();

                if (Resultado != "0")
                {
                    res = Resultado.Split('|')[1].ToString();
                    throw new Exception(res);
                }

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    return new DataTable();
                }

                
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

        }

    }
        

}
