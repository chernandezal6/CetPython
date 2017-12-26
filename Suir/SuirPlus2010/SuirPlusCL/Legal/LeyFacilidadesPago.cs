using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Legal 
{
    public class LeyFacilidadesPago : FrameWork.Objetos
    {
        public static string insertarSolicitudLeyFacilidadesPago(int idRegistroPatronal, string noDocumento, string tipoDoc, string idUsuario)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;
            arrParam[1] = new OracleParameter("p_noDocumento", OracleDbType.Varchar2, 25);
            arrParam[1].Value = noDocumento;
            arrParam[2] = new OracleParameter("p_tipoDoc", OracleDbType.Varchar2, 1);
            arrParam[2].Value = tipoDoc;
            arrParam[3] = new OracleParameter("p_usuario_registro", OracleDbType.Varchar2, 35);
            arrParam[3].Value = idUsuario;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.InsertSolicitudFacilidadesPago";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                string resultado = arrParam[4].Value.ToString();
                string[] Arr = resultado.Split('|');
                return Arr[1];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string updSolicitudLeyFacilidadesPago(int idSolicitud, Byte[] imageFile, string idUsuario, string status)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Int32);
            arrParam[0].Value = idSolicitud;

            arrParam[1] = new OracleParameter("p_documentos", OracleDbType.Blob);
            if (imageFile.LongLength > 0)
            {
                arrParam[1].Value = imageFile;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }

            arrParam[2] = new OracleParameter("p_usuario_registro", OracleDbType.Varchar2, 35);
            arrParam[2].Value = idUsuario;

            arrParam[3] = new OracleParameter("p_status", OracleDbType.Varchar2, 1);
            arrParam[3].Value = status;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.updSolicitudFacilidadesPago";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;

            }
        }

        public static DataTable getSolicitudFacilidadesPago(int? idSolicitud, int? idRegPat, string razon_social, string fecha_desde, string fecha_hasta,string status)
        {
            string Resultado = "0";
            OracleParameter[] arrParam = new OracleParameter[8];
            
            arrParam[0] = new OracleParameter("p_idsolicitud", OracleDbType.Int32);
            if (idSolicitud.HasValue)
            {
                arrParam[0].Value = idSolicitud.Value; 
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }
            
            arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            if (idRegPat.HasValue)
            {
                arrParam[1].Value = idRegPat.Value;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }
            
            arrParam[2] = new OracleParameter("p_razon_social", OracleDbType.Varchar2, 150);
            arrParam[2].Value = razon_social;

            arrParam[3] = new OracleParameter("p_fecha_desde", OracleDbType.Varchar2,10);
            arrParam[3].Value = fecha_desde;

            arrParam[4] = new OracleParameter("p_fecha_hasta", OracleDbType.Varchar2,10);
            arrParam[4].Value = fecha_hasta;

            arrParam[5] = new OracleParameter("p_status", OracleDbType.Varchar2, 1);
            arrParam[5].Value = status;

            arrParam[6] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;
            
            String cmdStr = "LGL_LEGAL_PKG.getSolicitudFacilidadesPago";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[7].Value.ToString();

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
                throw new Exception(Resultado + " | " + ex.ToString() );
            }


        }

        public static DataTable getStatusRecalculo(string rnc)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.Varchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getStatusRecalculo";

            try
            {
                DataSet ds =  DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
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

        public static DataTable getDeudaEmpleador(int regPat)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_regpat", OracleDbType.Int32);
            arrParam[0].Value = regPat;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getDeudaEmpleador";

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


        //public static DataTable getImagenesLeyFacilidadesPago(int? idSolicitud, int? idRegPat)
        //{
        //    OracleParameter[] arrParam = new OracleParameter[4];

        //    arrParam[0] = new OracleParameter("p_idsolicitud", OracleDbType.Int32);
        //    if (idSolicitud.HasValue)
        //    {
        //        arrParam[0].Value = idSolicitud.Value;
        //    }
        //    else
        //    {
        //        arrParam[0].Value = DBNull.Value;
        //    }

        //    arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
        //    if (idRegPat.HasValue)
        //    {
        //        arrParam[1].Value = idRegPat.Value;
        //    }
        //    else
        //    {
        //        arrParam[1].Value = DBNull.Value;
        //    }

        //    arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
        //    arrParam[2].Direction = ParameterDirection.Output;

        //    arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
        //    arrParam[3].Direction = ParameterDirection.Output;

        //    String cmdStr = "LGL_LEGAL_PKG.getImagenesLeyFacilidadesPago";

        //    try
        //    {
        //        return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;

        //    }

        //  }

        public static Byte[] getImagenesLeyFacilidadesPago(int? idSolicitud, int? idRegPat)
        {
            byte[] img = null;
            OracleDataReader odr = null;
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_idsolicitud", OracleDbType.Int32);
            if (idSolicitud.HasValue)
            {
                arrParam[0].Value = idSolicitud.Value;
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }

            arrParam[1] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            if (idRegPat.HasValue)
            {
                arrParam[1].Value = idRegPat.Value;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "LGL_LEGAL_PKG.getImagenesLeyFacilidadesPago";

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
                throw ex;

            }

            return img;

        }
    
        public override void CargarDatos()
		{

            //DataTable dt;
            //dt = Nomina.getNomina(this.myRegistroPatronal,this.IDNomina);

            //try
            //{

            //    this.myRegistroPatronal = Int32.Parse(dt.Rows[0]["id_registro_patronal"].ToString());
            //    this.NominaDes = dt.Rows[0]["nomina_des"].ToString();
            //    this.TipoNomina = dt.Rows[0]["tipo_nomina"].ToString();
            //    this.Estatus = dt.Rows[0]["status"].ToString();
		
            //    dt.Dispose();

            //}
            //catch(Exception ex)
            //{
            //    Exepciones.DataNoFoundException tmpException = new Exepciones.DataNoFoundException();
            //    tmpException.setMessage(ex.ToString());
            //    throw tmpException;
            //}
 
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
 
    }
}