using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Empresas
{
	/// <summary>
	/// En esta clase se colocaran todos los metodos utilizados para las consultas, los metodos que se introduzcan en esta clase deberan ser staticos.
	/// </summary>
	 public class Consultas
	{

		 private Consultas()
		 {
			//No es necesario hacer una instancia de esta clase.
		 }


		 public static DataTable getFacturasVencidasPorTipoEmpleador(string tipoEmpresa)
		 {

			 DataTable dtFactura;
			 string cmdStr = "SRE_CONSULTAS_PKG.Get_Factura_Valor";
			
			 OracleParameter[] arrParam = new OracleParameter[4];

			 arrParam[0] = new OracleParameter("p_TipoEmpresa", OracleDbType.NVarchar2,2);
			 arrParam[0].Value = tipoEmpresa;
					
			 arrParam[1] = new OracleParameter("p_Status", OracleDbType.NVarchar2, 2);
			 arrParam[1].Value = "VE";

			 arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			 arrParam[2].Direction = ParameterDirection.Output;

			 arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			 arrParam[3].Direction = ParameterDirection.Output;

			 try
			 {
			 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure,cmdStr, arrParam);
             if (ds.Tables.Count > 0)
             {
                 return ds.Tables[0];
             }
             return new DataTable("No Hay Data");
			 }
			 catch(Exception ex)
			 {
                 Exepciones.Log.LogToDB(ex.ToString());
				throw ex;
			 }
			
		 }

		 public static DataTable getReporteCobros(bool conLiquidacion, string criterioLiquidacion, bool conNotificacion, string criterioNotificacion)
		 {
		 
			 DataTable dtFacturas;
			string cmdStr = "SRE_CONSULTAS_PKG.Consulta_liq_not";

			 OracleParameter[] arrParam = new OracleParameter[6];
			
			arrParam[0] = new OracleParameter("p_liquidacion", OracleDbType.NVarchar2);
			arrParam[0].Value= (conLiquidacion ? "S" : "N");

			 arrParam[1] = new OracleParameter("p_criterio_liq", OracleDbType.NVarchar2);
			 arrParam[1].Value = criterioLiquidacion;

			 arrParam[2] = new OracleParameter("p_notificacion",OracleDbType.NVarchar2);
			 arrParam[2].Value = (conNotificacion ? "S" : "N");
			
			 arrParam[3] =new OracleParameter("p_criterio_not", OracleDbType.NVarchar2);
			 arrParam[3].Value = criterioNotificacion;

			 arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			 arrParam[4].Direction = ParameterDirection.Output;

			 arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,300);
			 arrParam[5].Direction = ParameterDirection.Output;
			
			 try
			 {
				 DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure,cmdStr, arrParam);
                 if (ds.Tables.Count > 0)
                 {
                     return ds.Tables[0];
                 }
                 return new DataTable("No Hay Data");
             }
			 catch(Exception ex)
			 {
                 Exepciones.Log.LogToDB(ex.ToString());
				 throw ex;
			 }

			 return dtFacturas;

		 }

         public static DataTable get_CxC_SectorPrivado(int desde, int hasta)
         {


             OracleParameter[] arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_desde", OracleDbType.Int16);
             arrParam[0].Value = desde;

             arrParam[1] = new OracleParameter("p_hasta", OracleDbType.Int16);;
             arrParam[1].Value = hasta;
             
             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
             arrParam[2].Direction = ParameterDirection.Output;
             
             arrParam[3] = new OracleParameter("p_io_cusor", OracleDbType.RefCursor);
             arrParam[3].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.cxc_sector_privado";

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

         public static DataTable get_CxC_SectorPublico(string TipoEmpresa, string TipoFactura, string Status)
         {

             OracleParameter[] arrParam = new OracleParameter[5];

             arrParam[0] = new OracleParameter("p_tipoEmpresa", OracleDbType.Varchar2);
             arrParam[0].Value = TipoEmpresa;

             arrParam[1] = new OracleParameter("p_tipoFactura", OracleDbType.Varchar2);
             arrParam[1].Value = TipoFactura;

             arrParam[2] = new OracleParameter("p_status", OracleDbType.Varchar2);
             arrParam[2].Value = Status;

             arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[3].Direction = ParameterDirection.Output;

             arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[4].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.CxC_sector_publico";

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

         public static DataTable get_CxC_auditoria()
         {

             OracleParameter[] arrParam = new OracleParameter[2];

             arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[0].Direction = ParameterDirection.Output;

             arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[1].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.CxC_auditoria";

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
         
         public static DataTable get_TipoFactura()
         {

             OracleParameter[] arrParam = new OracleParameter[2];

             arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[0].Direction = ParameterDirection.Output;

             arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[1].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.get_TipoFactura";

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

         public static DataTable get_RecIbanking(string desde, string hasta)
         {

             OracleParameter[] arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_fechaDesde", OracleDbType.Date);
             if (desde != string.Empty)
             {
                 arrParam[0].Value = Convert.ToDateTime(desde);
             }  
             
             arrParam[1] = new OracleParameter("p_fechaHasta", OracleDbType.Date);
             if (hasta != string.Empty)
             {
                 arrParam[1].Value = Convert.ToDateTime(hasta);
             } 

             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[2].Direction = ParameterDirection.Output;

             arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[3].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.rec_ibanking_x_rango_fech";

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
         
         public static DataTable get_NP_por_trabajadores(string NroDocumento)
         {

             OracleParameter[] arrParam = new OracleParameter[3];

             arrParam[0] = new OracleParameter("p_nroDocumento", OracleDbType.Varchar2);
             arrParam[0].Value = NroDocumento;

             arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[1].Direction = ParameterDirection.Output;

             arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[2].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.NP_por_trabajadores";

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

         public static DataTable get_Emp_pagan_via_TN()
         {

             OracleParameter[] arrParam = new OracleParameter[2];

             arrParam[0] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[0].Direction = ParameterDirection.Output;

             arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[1].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.Emp_pagan_via_TN";

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

         public static DataTable get_facturas_pagadas(string desde, string hasta)
         {

             OracleParameter[] arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_fechaDesde", OracleDbType.Date);
             if (desde != string.Empty)
             {
                 arrParam[0].Value = Convert.ToDateTime(desde);
             }  
             
             arrParam[1] = new OracleParameter("p_fechaHasta", OracleDbType.Date);
             if (hasta != string.Empty)
             {
                 arrParam[1].Value = Convert.ToDateTime(hasta);
             } 

             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[2].Direction = ParameterDirection.Output;

             arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[3].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.facturas_pagadas";

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

         public static DataTable get_CxC_MesActual(string Provincia, int Monto, int desde, int hasta)
         {
             OracleParameter[] arrParam = new OracleParameter[6];

             arrParam[0] = new OracleParameter("p_idprovincia", OracleDbType.Varchar2);
             arrParam[0].Value = Provincia;
             arrParam[1] = new OracleParameter("p_monto", OracleDbType.Int32);
             arrParam[1].Value = Monto;
             arrParam[2] = new OracleParameter("p_desde", OracleDbType.Int32);
             arrParam[2].Value = desde;
             arrParam[3] = new OracleParameter("p_hasta", OracleDbType.Int32);
             arrParam[3].Value = hasta;
             arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[4].Direction = ParameterDirection.Output;
             arrParam[5] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[5].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.cxc_mes_actual";

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

         public static DataTable get_Resumen_AcuerdoPago(string desde, string hasta)
         {

             OracleParameter[] arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_fecha_Desde", OracleDbType.Date);
             if (desde != string.Empty)
             {
                 arrParam[0].Value = Convert.ToDateTime(desde);
             }

             arrParam[1] = new OracleParameter("p_fecha_Hasta", OracleDbType.Date);
             if (hasta != string.Empty)
             {
                 arrParam[1].Value = Convert.ToDateTime(hasta);
             }

             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[2].Direction = ParameterDirection.Output;

             arrParam[3] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[3].Direction = ParameterDirection.Output;

             string cmdStr = " sfc_reportes_pkg.resumenacuerdopago";

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

         public static DataTable get_Cartera_Legal_MDT(string Provincia, string TipoEmpresa,string tipoReporte, string periodo)
         {

             OracleParameter[] arrParam = new OracleParameter[6];

             arrParam[0] = new OracleParameter("p_Idprovincia", OracleDbType.Varchar2);
             arrParam[0].Value = Provincia;

             arrParam[1] = new OracleParameter("p_TipoEmpresa", OracleDbType.Varchar2);
             arrParam[1].Value = TipoEmpresa;

             arrParam[2] = new OracleParameter("p_TipoReporte", OracleDbType.Varchar2);
             arrParam[2].Value = tipoReporte;

             arrParam[3] = new OracleParameter("p_periodo", OracleDbType.Varchar2);
             arrParam[3].Value = periodo;
             
             arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[4].Direction = ParameterDirection.Output;

             arrParam[5] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[5].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.getCarteraLegalMDT";

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

         public static string getEmpMontoCarteraLegal(ref Int32 p_total_empresas, ref Decimal p_monto_empresas)
         {
             OracleParameter[] arrParam;

             arrParam = new OracleParameter[3];

             arrParam[0] = new OracleParameter("p_total_empresas", OracleDbType.Int32);
             arrParam[0].Direction = ParameterDirection.Output;

             arrParam[1] = new OracleParameter("p_monto_empresas", OracleDbType.Decimal);
             arrParam[1].Direction = ParameterDirection.Output;

             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[2].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.getempMontoCarteraLegal";
                                                
             string res = string.Empty;
             try
             {
                 OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                 p_total_empresas = Convert.ToInt32(arrParam[0].Value.ToString());
                 p_monto_empresas = Convert.ToDecimal(arrParam[1].Value.ToString());
                 res = arrParam[2].Value.ToString();  
                 return res;
             }

             catch (Exception ex)
             {
                 return ex.ToString();
             }
         }

         public static string getEmpMontoEnviadosMDT(ref Int32 p_total_empresas, ref Decimal p_monto_empresas)
         {
             OracleParameter[] arrParam;

             arrParam = new OracleParameter[3];

             arrParam[0] = new OracleParameter("p_total_empresas", OracleDbType.Int32);
             arrParam[0].Direction = ParameterDirection.Output;

             arrParam[1] = new OracleParameter("p_monto_empresas", OracleDbType.Decimal);
             arrParam[1].Direction = ParameterDirection.Output;

             arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
             arrParam[2].Direction = ParameterDirection.Output;

             string cmdStr = "sfc_reportes_pkg.getEmpMontoEnviadoMDT";
             string res = string.Empty;
             try
             {
                 OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                 p_total_empresas = Convert.ToInt32(arrParam[0].Value.ToString());
                 p_monto_empresas = Convert.ToDecimal(arrParam[1].Value.ToString());
                 res = arrParam[2].Value.ToString();
                 return res;
             }

             catch (Exception ex)
             {
                 return ex.ToString();
             }
         }

         public static DataTable getPeriodosCarteraLegal()
         {

             OracleParameter[] arrParam = new OracleParameter[2];

             arrParam[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[0].Direction = ParameterDirection.Output;
             arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[1].Direction = ParameterDirection.Output;

             String cmdStr = "sfc_reportes_pkg.periodocarteralegal";

             try
             {
                 return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
             }
             catch (Exception ex)
             {
                 throw ex;
             }

         }
         public static DataTable getInfoLote(string lote, string numdetalle, int pagenum, int pagesize)
         {

             OracleParameter[] arrParam = new OracleParameter[6];


             arrParam[0] = new OracleParameter("p_lote", OracleDbType.Varchar2);
             arrParam[0].Value = lote;

             arrParam[1] = new OracleParameter("p_id_registro", OracleDbType.Varchar2);
             arrParam[1].Value = numdetalle;

             arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int32);
             arrParam[2].Value = pagenum;

             arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int32);
             arrParam[3].Value = pagesize;

             arrParam[4] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[4].Direction = ParameterDirection.Output;

             arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[5].Direction = ParameterDirection.Output;



             string cmdStr = "ars_solicitudes_pkg.getinfolote";

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


         public static DataTable getImagenRegLote(string lote, string id_registro)
         {

             OracleParameter[] arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_lote", OracleDbType.Varchar2);
             arrParam[0].Value = lote;

             arrParam[1] = new OracleParameter("p_id_registro", OracleDbType.Varchar2);
             arrParam[1].Value = id_registro;
             arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[2].Direction = ParameterDirection.Output;
             arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[3].Direction = ParameterDirection.Output;

             String cmdStr = "ars_solicitudes_pkg.getImagenRegLote";

             try
             {
                 return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
             }
             catch (Exception ex)
             {
                 throw ex;
             }

         }


         public static DataTable getInfoAsignacion(string lote, string id_Registro)
         {

             OracleParameter[] arrParam = new OracleParameter[4];


             arrParam[0] = new OracleParameter("p_lote", OracleDbType.Varchar2);
             arrParam[0].Value = lote;

             arrParam[1] = new OracleParameter("p_id_registro", OracleDbType.Varchar2);
             arrParam[1].Value = id_Registro;

             arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
             arrParam[2].Direction = ParameterDirection.Output;

             arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 1000);
             arrParam[3].Direction = ParameterDirection.Output;



             string cmdStr = "ars_solicitudes_pkg.getInfoAsignacion";

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


         public static DataTable get_UltimosArchivos(string rnc_cedula,string cedula)
         {

             OracleParameter[] arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_rnc_cedula", OracleDbType.Varchar2);
             arrParam[0].Value = rnc_cedula;

             arrParam[1] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
             if (string.IsNullOrEmpty(cedula))
             {
                 arrParam[1].Value = DBNull.Value;
             }
             else
             {
                 arrParam[1].Value = cedula;
             }
           

             arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[2].Direction = ParameterDirection.Output;

             arrParam[3] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 1000);
             arrParam[3].Direction = ParameterDirection.Output;

             string cmdStr = "SRE_CONSULTAS_PKG.getUltimosArchivos";

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


         public static DataTable get_UltimosNovedades(string rnc_cedula,string cedula)
         {

             OracleParameter[] arrParam = new OracleParameter[4];

             arrParam[0] = new OracleParameter("p_rnc_cedula", OracleDbType.Varchar2);
             arrParam[0].Value = rnc_cedula;

             arrParam[1] = new OracleParameter("p_cedula", OracleDbType.Varchar2);
             if (string.IsNullOrEmpty(cedula))
             {
                 arrParam[1].Value = DBNull.Value;
             }
             else
             {
                 arrParam[1].Value = cedula;
             }

             arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[2].Direction = ParameterDirection.Output;

             arrParam[3] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 1000);
             arrParam[3].Direction = ParameterDirection.Output;

             string cmdStr = "SRE_CONSULTAS_PKG.getUltimasNovedades";

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


         public static DataTable get_UltimosSubsidios(string rnc_cedula)
         {

             OracleParameter[] arrParam = new OracleParameter[3];

             arrParam[0] = new OracleParameter("p_rnc_cedula", OracleDbType.Varchar2);
             arrParam[0].Value = rnc_cedula;

             arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
             arrParam[1].Direction = ParameterDirection.Output;

             arrParam[2] = new OracleParameter("p_RESULTNUMBER", OracleDbType.Varchar2, 1000);
             arrParam[2].Direction = ParameterDirection.Output;

             string cmdStr = "SRE_CONSULTAS_PKG.getUltimasSubsidios";

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

        public static DataTable getSolicitudNSS(string solicitud, string tipo_documento,string nro_documento,string lote, string registro,int pageNum ,int pageSize)
        {          

            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Varchar2);
            arrParam[0].Value = solicitud;

            arrParam[1] = new OracleParameter("p_tipo_documento", OracleDbType.Varchar2);
            arrParam[1].Value = tipo_documento;

            arrParam[2] = new OracleParameter("p_no_documento", OracleDbType.Varchar2);
            arrParam[2].Value = nro_documento;

            arrParam[3] = new OracleParameter("p_num_control", OracleDbType.Varchar2);                           
            arrParam[3].Value = lote;

            arrParam[4] = new OracleParameter("p_id_control", OracleDbType.Varchar2);
            arrParam[4].Value = registro;

            arrParam[5] = new OracleParameter("p_PageNum", OracleDbType.Int32);
            arrParam[5].Value = pageNum;

            arrParam[6] = new OracleParameter("p_PageSize", OracleDbType.Int32);
            arrParam[6].Value = pageSize;

            arrParam[7] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[7].Direction = ParameterDirection.Output;

            arrParam[8] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 500);
            arrParam[8].Direction = ParameterDirection.InputOutput;

            string cmdStr = "NSS_GET_SOLICITUD";
            try
            {
                DataTable dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    return dt;
                }
                return new DataTable("No Hay Data");
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }

        public static DataTable getSolicitudRnc(string Rnc, string Estatus, string FechaDesde, string FechaHasta, int pageNum, int pageSize)
        {

            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("P_RNC", OracleDbType.Varchar2);
            arrParam[0].Value = Rnc;

            arrParam[1] = new OracleParameter("P_ID_ESTATUS", OracleDbType.Varchar2);
            arrParam[1].Value = Estatus;

            arrParam[2] = new OracleParameter("P_FECHA_DESDE", OracleDbType.Date);
            if (FechaDesde != "")
            {
                arrParam[2].Value = Convert.ToDateTime(FechaDesde);
            }
            else
            {
                arrParam[2].Value = DBNull.Value;
            }               

            arrParam[3] = new OracleParameter("P_FECHA_HASTA", OracleDbType.Date);
            if (FechaHasta != "")
            {
                arrParam[3].Value = Convert.ToDateTime(FechaHasta);
            }
            else
            {
                arrParam[3].Value = DBNull.Value;
            }

            arrParam[4] = new OracleParameter("p_PageNum", OracleDbType.Int32);
            arrParam[4].Value = pageNum;

            arrParam[5] = new OracleParameter("p_PageSize", OracleDbType.Int32);
            arrParam[5].Value = pageSize;

            arrParam[6] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 500);
            arrParam[7].Direction = ParameterDirection.InputOutput;

            string cmdStr = "NSS_GET_SOLICITUD_RNC";
            try
            {
                DataTable dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    return dt;
                }
                return new DataTable("No Hay Data");
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

        }

        public static DataTable getSolicitudEvaluacionVisual(string solicitud, string tipoSolicitud,int pageNum, int pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Varchar2);
            arrParam[0].Value = solicitud;

            arrParam[1] = new OracleParameter("p_id_tipo", OracleDbType.Varchar2);
            arrParam[1].Value = tipoSolicitud;

            arrParam[2] = new OracleParameter("p_PageNum", OracleDbType.Int32);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_PageSize", OracleDbType.Int32);
            arrParam[3].Value = pageSize;

            arrParam[4] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 500);
            arrParam[5].Direction = ParameterDirection.InputOutput;

            string cmdStr = "NSS_GET_EVALUACION_VISUAL";
            try
            {
                DataTable dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    return dt;
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
