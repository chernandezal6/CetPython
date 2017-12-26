using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;
using SuirPlus;
using System.Data;
using System;

namespace SuirPlus.Empresas.Facturacion
{
	
	/// Summary description for ResumenDeclaracionIR13.
	public class ResumenDeclaracionIR13 : SuirPlus.FrameWork.Objetos
	{

		private int myAnoFiscal;
		private string myRNC;
		private string myStatus;

		public string Status
		{
			get 
			{
				if(this.myStatus!= "P")	
				{
					return "Pendiente";
				}
				else
				{
					return "Procesado";
				}
											
			}										
		}

		public string RNC
		{
			get {return this.myRNC;}
		}

		public int AnoFiscal
		{
			get {return this.myAnoFiscal;}
		}

		public ResumenDeclaracionIR13(int anoFiscal, string rnc)
		{
			this.myAnoFiscal = anoFiscal;
			this.myRNC = rnc;
			this.CargarDatos();

		}

        public DataTable getResumenIR13()
		{
			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_IR13.Resumen_ir13";

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

        public  bool isTieneSaldoDGII()
        {
            OracleParameter[] arrParam = new OracleParameter[4];
           

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
            arrParam[0].Value = this.myRNC;

            arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
            arrParam[1].Value = this.myAnoFiscal;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_IR13.SaldoDGII";

            try
                {
                    if (DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0].Rows.Count > 0)
                    {
                        return true;

                    }
                    else
                    {
                        return false;
                    
                    }
                }
            catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
        }
        
        public DataTable getPageResumenIR13(Int16 pageNum, Int16 pageSize)
		{
			OracleParameter[] arrParam  = new OracleParameter[6];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[3].Value = pageSize;

			arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[4].Direction = ParameterDirection.Output;

			arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[5].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_IR13.PageResumen_ir13";

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
                    SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }

		}

		public DataTable getDetallePorPeriodoIR13(int periodo)
		{
			OracleParameter[] arrParam  = new OracleParameter[5];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

			arrParam[2] = new OracleParameter("p_periodo", OracleDbType.Decimal);
			arrParam[2].Value = periodo;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[3].Direction = ParameterDirection.Output;

			arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_ir13.Detalle_Periodo";

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

        public DataTable getPageDetallePorPeriodoIR13(int periodo, Int16 pageNum, Int16 pageSize)
		{
			OracleParameter[] arrParam  = new OracleParameter[7];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

			arrParam[2] = new OracleParameter("p_periodo", OracleDbType.Decimal);
			arrParam[2].Value = periodo;

            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[3].Value = pageNum;

            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[4].Value = pageSize;

			arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[5].Direction = ParameterDirection.Output;

			arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_ir13.getPageDetalle_Periodo";

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

		public DataTable getPeriodosOmisos()
		{
			string cmdStr = "SFC_IR13.GET_PERIODOS_OMISOS";
			OracleParameter[] arrParam = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

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

		public DataTable getPeriodosVencidos()
		{
			string cmdStr = "SFC_IR13.GET_PERIODOS_VENCIDOS";
			OracleParameter[] arrParam = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

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
		
		public DataTable getIR13StatusNulos()
		{
			string cmdStr = "SFC_IR13.GET_IR13_ESTATUS_NULO";
			OracleParameter[] arrParam = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

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

		public DataTable getIR13HechasEnDGII()
		{
			string cmdStr = "SFC_IR13.GET_IR13_HECHAS_EN_DGII";
			OracleParameter[] arrParam = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.AnoFiscal;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
			arrParam[3].Direction = ParameterDirection.Output;

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

		public DataTable getPeriodos()
		{
			OracleParameter[] arrParam  = new OracleParameter[4];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

			arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[2].Direction = ParameterDirection.Output;

			arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[3].Direction = ParameterDirection.Output;

			String cmdStr= "SFC_IR13.Listado_Periodos";

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
		
		public void MarcarProcesado()
		{
			
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = this.myRNC;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = this.myAnoFiscal;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure,"SFC_IR13.Marcar_Procesado",arrParam);	

		}

        public void DesmarcarProcesado(string Usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
            arrParam[0].Value = this.myRNC;

            arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
            arrParam[1].Value = this.myAnoFiscal;

            arrParam[2] = new OracleParameter("p_IdUsuario", OracleDbType.NVarchar2, 35);
            arrParam[2].Value = Usuario;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SFC_IR13.Desmarcar_Procesado", arrParam);

        }

        public override void CargarDatos()
		{
			DataTable dt;
			string cmdStr = "SFC_IR13.Cons_Status";
			
	
				OracleParameter[] arrParam  = new OracleParameter[4];
				arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
				arrParam[0].Value = this.myRNC;

				arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
				arrParam[1].Value = this.myAnoFiscal;
				
				arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
				arrParam[2].Direction = ParameterDirection.Output;

				arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
				arrParam[3].Direction = ParameterDirection.Output;

				try
				    {
					    dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                            this.myStatus = dt.Rows[0][0].ToString();

				    }
				catch(Exception ex)
                    {
                        Exepciones.Log.LogToDB(ex.ToString());
                        throw ex;
                    }

		}

		public string ReProcesar(string Rnc, string Anio)
		{
			
			string cmdStr = "SFC_IR13.PROCESAR";

			OracleParameter[] arrParam  = new OracleParameter[3];
			arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2);
			arrParam[0].Value = Rnc;

			arrParam[1] = new OracleParameter("p_ano", OracleDbType.Decimal);
			arrParam[1].Value = Anio;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
			arrParam[2].Direction = ParameterDirection.Output;

			try
			    {
				    DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
				    return arrParam[2].Value.ToString();
			    }
			catch(Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
		}

		public override String GuardarCambios(string UsuarioResponsable)
		{
		    return "";
		}

        public DataTable PageDetalleIR13(Int16 pageNum, Int16 pageSize)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2);
            arrParam[0].Value = this.myRNC;

            arrParam[1] = new OracleParameter("p_ano_fiscal", OracleDbType.Int16);
            arrParam[1].Value = this.myAnoFiscal;

            arrParam[2] = new OracleParameter("p_pageNumero", OracleDbType.Int16);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_pageCantidad", OracleDbType.Int16);
            arrParam[3].Value = pageSize;

            arrParam[4] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "SFC_IR13.PageDetalleIR13";
                    
            try
                {
                    return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                }
            catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                }
        }

        }
}
