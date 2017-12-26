using System;
using SuirPlus;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Bancos
{
	/// <summary>
	/// Summary description for Dgii.
	/// </summary>
	public class Dgii
	{
				
		public Dgii()
		{
						
		}
        		
        //Probando procedimiento del Web Service.
        public static string isExisteReferenciaAutorizada(string Ref)
		{

            DataTable dtRef;
			string strCmd = "Sre_Empleadores_Pkg.Get_ValidaReferenciaAutorizada";
			string resultado = string.Empty;
			string validacion = string.Empty;

			OracleParameter[] arrParam = new OracleParameter[2];

			arrParam[0] = new OracleParameter("p_referencia", OracleDbType.NVarchar2,11);
			arrParam[0].Value = Ref;

			arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,1);
			arrParam[1].Direction = ParameterDirection.Output;
            
			try
			    {
                    dtRef = SuirPlus.DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, strCmd, arrParam).Tables[0];
                    return arrParam[1].Value.ToString();
                    
                }

            catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
        }

        //cambió metodo "getNombreArchivos" devolvía string ahora devolverá datatable

        public static string getNombreArchivos(Int32 idrecepcion, string tipoarchivo)
        {
            string fileName = string.Empty;
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Decimal);
            arrParam[0].Value = idrecepcion;
            arrParam[1] = new OracleParameter("p_tipo_archivo", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = tipoarchivo;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_DGII_PKG.Get_Nombre_Archivo";

            try
            {
                
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {
                    fileName = ds.Tables[0].Rows[0][0].ToString();
                    return fileName;
                }
                return "No Hay Data";
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return fileName;
        }

        //public static DataTable getNombreArchivos(Int32 idrecepcion, string tipoarchivo)
        //{
        //    string fileName = string.Empty;
        //    OracleParameter[] arrParam = new OracleParameter[4];

        //    arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Decimal);
        //    arrParam[0].Value = idrecepcion;
        //    arrParam[1] = new OracleParameter("p_tipo_archivo", OracleDbType.NVarchar2, 1);
        //    arrParam[1].Value = tipoarchivo;
        //    arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
        //    arrParam[2].Direction = ParameterDirection.Output;
        //    arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
        //    arrParam[3].Direction = ParameterDirection.Output;

        //    String cmdStr = "SFC_DGII_PKG.Get_Nombre_Archivo";

        //    try
        //    {
        //        DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
        //        if (ds.Tables.Count > 0)
        //        {
        //            return ds.Tables[0];
        //        }
        //        return new DataTable("No Hay Data");
        //    }

        //    catch (Exception ex)
        //    {
        //        Exepciones.Log.LogToDB(ex.ToString());
        //        throw ex;
        //    }
        //}

        public static string EnvioCorreo(DateTime FechaInicial, DateTime FechaFinal, Int64 Banco, String Correo)
        {


            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_fecha_inicial", OracleDbType.Date);
            arrParam[0].Value = FechaInicial;
            arrParam[1] = new OracleParameter("p_fecha_final", OracleDbType.Date);
            arrParam[1].Value = FechaFinal;
            arrParam[2] = new OracleParameter("p_entidad_recaudadora", OracleDbType.Decimal);
            arrParam[2].Value = Banco;
            arrParam[3] = new OracleParameter("p_enviar_a", OracleDbType.NVarchar2, 100);
            arrParam[3].Value = Correo;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_reportes_por_mail_pkg.resumen_pagos_aclaraciones";

            try
                {
                    DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                    return arrParam[4].Value.ToString();
                }
            catch (Exception ex)
            {
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
            }
        }

        public static DataTable getResumenAclaraciones()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_DGII_PKG.Get_Aclaraciones";

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

        public static DataTable getPageResumenAclaraciones(Int32 pageNum, Int32 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[4];
            arrParam[0] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[0].Value = pageNum;
            arrParam[1] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[1].Value = pageSize;
            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_DGII_PKG.getpageAclaraciones";

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
		
		public static DataTable getArchivosProcesados(Int64 numerolote, DateTime fechaIni,DateTime fechaFin )
		{
			OracleParameter[] arrParam  = new OracleParameter[5];
            arrParam[0] = new OracleParameter("p_numerolote", OracleDbType.Decimal);
			//arrParam[0].Value = Utilitarios.Utils.verificarNulo(numerolote);
			arrParam[0].Value = numerolote;
			arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
			arrParam[1].Value = fechaIni;
			arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
			arrParam[2].Value = fechaFin;
			arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.Get_ArchivosProcesados";

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

        public static DataTable getDetalleRecaudoPagos(Int64 entidad, DateTime fechaIni,DateTime fechaFin )
		{
			
			OracleParameter[] arrParam  = new OracleParameter[5];
			arrParam[0] = new OracleParameter("p_identidad_rec", OracleDbType.Decimal);
			//arrParam[0].Value = Utilitarios.Utils.verificarNulo(numerolote);
			arrParam[0].Value = entidad;
			arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
			arrParam[1].Value = fechaIni;
			arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
			arrParam[2].Value = fechaFin;
			arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.Get_DetallesRecaudacionPago";

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
			
        public static DataTable getDetalleRecaudoAclara(Int64 entidad, DateTime fechaIni, DateTime fechaFin )
		{
			

			//throw new Exception(numerolote.ToString() + fechaIni.ToString() + fechaFin.ToString());

			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_identidad_rec", OracleDbType.Decimal);
			//arrParam[0].Value = Utilitarios.Utils.verificarNulo(numerolote);
			arrParam[0].Value = entidad;
			arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
			arrParam[1].Value = fechaIni;
			arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
			arrParam[2].Value = fechaFin;
			arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.Get_DetallesRecaudacionAcla";

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

        public static DataTable getArchivosReferencia(Int32 numerolote, Int32 entidad)
		{
			            		
			OracleParameter[] arrParam  = new OracleParameter[4];
	
			arrParam[0] = new OracleParameter("p_numerolote", OracleDbType.Int32);			
			arrParam[0].Value = numerolote;

			arrParam[1] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Int32);			
			arrParam[1].Value = entidad;
                       
			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_DGII_PKG.get_ArchivosReferencia";

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

        public static DataTable getArchivosErrores(Int64 numerorecepcion)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];
			arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Decimal);
			arrParam[0].Value = numerorecepcion;
			arrParam[1] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.get_Error_Archivo";

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

        public static DataTable getCuentaPagos(Int64 numeroentidad, DateTime fechaIni,DateTime fechaFin)
		{
			
            OracleParameter[] arrParam  = new OracleParameter[5];
            arrParam[0] = new OracleParameter("p_entidad", OracleDbType.Decimal);
			arrParam[0].Value = numeroentidad;
			arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
			arrParam[1].Value = fechaIni;
			arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
			arrParam[2].Value = fechaFin;	
			arrParam[3] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;
			arrParam[4] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.get_cuenta_pagos";

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

        public static DataTable getCuentaAclaraciones(Int64 numeroentidad, DateTime fechaIni, DateTime fechaFin)
		{
			
			OracleParameter[] arrParam  = new OracleParameter[5];
            arrParam[0] = new OracleParameter("p_entidad", OracleDbType.Decimal);
			arrParam[0].Value = numeroentidad;
			arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
			arrParam[1].Value = fechaIni;
			arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
			arrParam[2].Value = fechaFin;
			arrParam[3] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;
			arrParam[4] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.get_cuenta_aclaraciones";

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

		public static DataTable getArchivosFechas(DateTime fechaIni, DateTime fechaFin, Int32 entidad, Int32 pageNum, Int16 pageSize)
		{
			OracleParameter[] arrParam  = new OracleParameter[7];

			arrParam[0] = new OracleParameter("p_fechaini", OracleDbType.Date);
			arrParam[0].Value = fechaIni;

			arrParam[1] = new OracleParameter("p_fechafin", OracleDbType.Date);
			arrParam[1].Value = fechaFin;

			arrParam[2] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Int32);
			arrParam[2].Value = entidad;

            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[3].Value = pageNum;

            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[4].Value = pageSize;

			arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[5].Direction = ParameterDirection.Output;

			arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_DGII_PKG.getPage_ArchivosFechas";

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

        public static DataTable getResumenAclaracionesDet(int entRec)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_identidad_rec", OracleDbType.Decimal);
			arrParam[0].Value = Utilitarios.Utils.verificarNulo(entRec);
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.Get_DetallesAclaraciones";

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

        public static DataTable getPageResumenAclaracionesDet(int entRec, string rango,Int32 pageNum, Int32 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_identidad_rec", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(entRec);
            arrParam[1] = new OracleParameter("p_rango", OracleDbType.Varchar2);
            arrParam[1].Value = rango;
            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[2].Value = pageNum;
            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[3].Value = pageSize;
            arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_DGII_PKG.getpageDetallesAclaraciones";

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

		public static DataTable getResumenRecaudacion(DateTime fechaIni, DateTime fechaFin,	string requerimiento)
		{
			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_fechaini", OracleDbType.Date);
			arrParam[0].Value = fechaIni;
			arrParam[1] = new OracleParameter("p_fechafin", OracleDbType.Date);
			arrParam[1].Value = fechaFin;
			arrParam[2] = new OracleParameter("p_requerimiento", OracleDbType.NVarchar2, 200);
			arrParam[2].Value = requerimiento;
			arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.Get_ResumenRecaudacion";

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

		public static DataTable getEntidadRecaudadora()
		{
			

			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;
		
			String cmdStr= "SRP_OPERACIONES_PKG.get_EntidadRecaudadora";

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

		public static DataTable getArchivosDGII_1(Int64 entidad, DateTime fechaIni, DateTime fechaFin )
		{
			

			//throw new Exception(numerolote.ToString() + fechaIni.ToString() + fechaFin.ToString());

			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_entidadrec", OracleDbType.Decimal);
			arrParam[0].Value = entidad;
			arrParam[1] = new OracleParameter("p_fechaini", OracleDbType.Date);
			arrParam[1].Value = fechaIni;
			arrParam[2] = new OracleParameter("p_fechafin", OracleDbType.Date);
			arrParam[2].Value = fechaFin;
			arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;
			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

			String cmdStr= "Sfc_Dgii_Pkg.Get_ArchivoDGII";

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

		public static DataTable getArchivosDGII_2(Int32 idrecepcion)
		{
			            	
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_idrecepcion", OracleDbType.Decimal);
			arrParam[0].Value = idrecepcion;
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "Sfc_Dgii_Pkg.Get_ArchivoDGII2";

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

		public static DataTable getBanco()
		{
			

			OracleParameter[] arrParam  = new OracleParameter[1];

			arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[0].Direction = ParameterDirection.Output;
		
			String cmdStr= "Sfc_Dgii_Pkg.get_Bancos";

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

		public static DataTable getRespuestaPagos(Int32 idrecepcion)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Decimal);
			arrParam[0].Value = idrecepcion;
			arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;
		
			String cmdStr= "sre_procesar_EP_pkg.GetArchivoRespuesta";

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

		public static DataTable getRespuestaAclaraciones(Int32 idrecepcion)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Decimal);
			arrParam[0].Value = idrecepcion;
			arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;
		
			String cmdStr= "sre_procesar_AC_pkg.GetArchivoRespuesta";

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

		public static DataTable getResumenRecaudacionDet(int identidadRec)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_identidad_rec", OracleDbType.Decimal);
			arrParam[0].Value = identidadRec;
			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;
			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_DGII_PKG.getDetallesAclaraciones";

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

        public static DataTable getArchivosDGII(string numLote,string fechaIni, string fechaFin, Int32 entidad, Int32 pageNum, Int16 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_numeroLote", OracleDbType.Int32);
            if (numLote != string.Empty)
            {
                arrParam[0].Value = Convert.ToInt32(numLote);
            }   
            
            arrParam[1] = new OracleParameter("p_fechaDesde", OracleDbType.Date);
            if (fechaIni != string.Empty)
            {
                arrParam[1].Value = Convert.ToDateTime(fechaIni);
            }            

            arrParam[2] = new OracleParameter("p_fechaHasta", OracleDbType.Date);
            if (fechaFin != string.Empty)
            { 
            arrParam[2].Value = Convert.ToDateTime(fechaFin);
            }       

            arrParam[3] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Int32);
            arrParam[3].Value = entidad;

            arrParam[4] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[4].Value = pageNum;

            arrParam[5] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[5].Value = pageSize;

            arrParam[6] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_DGII_PKG.getPage_ArchivosDGII";

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



