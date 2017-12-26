using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;

namespace SuirPlus.Bancos
{
    public class EntidadRecaudadora : FrameWork.Objetos
    {
        #region "Constructores de la Clase'
        public EntidadRecaudadora()
        {

        }

        public EntidadRecaudadora(UInt32 IdEntidadRecaudadora)
        {
            this.IdEntidadRecaudadora = IdEntidadRecaudadora;
            this.CargarDatos();

        }
        #endregion

        #region "Miembros y Propiedades Publicas"
        private UInt32 idEntidadRecaudadora;

        public UInt32 IdEntidadRecaudadora
        {
            get { return idEntidadRecaudadora; }
            set { idEntidadRecaudadora = value; }
        }
        private string descripcion; // ENTIDAD_RECAUDADORA_DES

        public string Descripcion
        {
            get { return descripcion; }
            set { descripcion = value; }
        }
        private string cuenta; // CUENTA_RECAUDADORA

        public string Cuenta
        {
            get { return cuenta; }
            set { cuenta = value; }
        }
        #endregion

        #region "Metodos de la clase"
        /// <summary>
        /// Metodo para obtener el listado de Entidades Recaudadora Para SFS
        /// </summary>
        /// <returns></returns>
        /// 

        public static DataTable getEntidadesParaSFS()
        {
            OracleParameter[] parameters = new OracleParameter[1];
            parameters[0] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor, ParameterDirection.Output);

            try
                {
                    DataSet ds = OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFC_ENTIDAD_RECAUDADORA_PKG.Entidad_Recaudadora_All", parameters);
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

        public static DataTable getEntidadRecaudadora(UInt32 IdEntidadRecaudadora)
		{
			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Date);
			arrParam[0].Value = IdEntidadRecaudadora;

			arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "BCO_BANCOS_PKG.Entidad_Recaudadora_Cons_1";

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
        
        public override void CargarDatos()
        {
            DataTable dt = null;

            try
                {
                    dt = Bancos.EntidadRecaudadora.getEntidadRecaudadora(this.idEntidadRecaudadora);

                    if (dt.Rows.Count > 0)
                    {
                        this.IdEntidadRecaudadora = Convert.ToUInt32(dt.Rows[0]["ID_ENTIDAD_RECAUDADORA"]);
                        this.Descripcion = dt.Rows[0]["ENTIDAD_RECAUDADORA_DES"].ToString();
                        this.Cuenta = dt.Rows[0]["CUENTA_RECAUDADORA"].ToString();
                    }
                }
            catch (Exepciones.DataNoFoundException ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw new Exception(ex.Message); 
                }
        }

        public override string GuardarCambios(string UsuarioResponsable)
        {
            return string.Empty;
        }

        #endregion
        #region "Metodos para el manejo de la pagina Bancos/EntidadRecaudadoras.aspx"
        
        public static DataTable getBancos(int? idEntidad)
        {
            if (idEntidad == 0)
            {
                idEntidad = null;
            }

            OracleParameter[] arrayParam = new OracleParameter[3];

            arrayParam[0] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Int32);
            arrayParam[0].Direction = ParameterDirection.Input;
            arrayParam[0].Value = idEntidad;
            arrayParam[1] = new OracleParameter("P_IOCURSOR", OracleDbType.RefCursor);
            arrayParam[1].Direction = ParameterDirection.Output;
            arrayParam[2] = new OracleParameter("P_RESULTNUMBER", OracleDbType.Varchar2, 100);
            arrayParam[2].Direction = ParameterDirection.Output;

            string nombreProcedure = "SFC_ENTIDAD_RECAUDADORA_PKG.GETENTIDADRECAUDADORA";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, nombreProcedure, arrayParam);
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
        #region

        /// <summary>
        /// Obtiene los tipos de impuesto.
        /// </summary>
        /// <returns>datatable</returns>
        public static DataTable getTiposImpuestos()
        {
            OracleParameter[] arrayParam = new OracleParameter[2];


            arrayParam[1] = new OracleParameter("P_IOCURSOR", OracleDbType.RefCursor);
            arrayParam[1].Direction = ParameterDirection.Output;
            arrayParam[2] = new OracleParameter("P_RESULTNUMBER", OracleDbType.Varchar2, 200);
            arrayParam[2].Direction = ParameterDirection.Output;
            
            string nombreProcedure = "SFS_ENTIDAD_RECAUDADORA_PKG.GetTiposImpuesto";

            try
                {
                   DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, nombreProcedure, arrayParam);
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

        /// Actualiza los diferentes tipos de impuestos que se le pueden asignar a un banco especifico.
        public static void updateEntidades(int id, int tss, int infoted, int dgii)
        {
            OracleParameter[] arrayParam = new OracleParameter[5];

            arrayParam[0] = new OracleParameter("p_id_entidad_recaudadora", OracleDbType.Decimal);
            arrayParam[0].Direction = ParameterDirection.Input;
            arrayParam[0].Value = id;
            arrayParam[1] = new OracleParameter("P_TSS", OracleDbType.Int32);
            arrayParam[1].Direction = ParameterDirection.Input;
            arrayParam[1].Value = tss;
            arrayParam[2] = new OracleParameter("P_INF", OracleDbType.Int32);
            arrayParam[2].Direction = ParameterDirection.Input;
            arrayParam[2].Value = infoted;
            arrayParam[3] = new OracleParameter("P_DGII", OracleDbType.Int32);
            arrayParam[3].Direction = ParameterDirection.Input;
            arrayParam[3].Value = dgii;

            arrayParam[4] = new OracleParameter("P_RESULTNUMBER", OracleDbType.Varchar2, 100);
            arrayParam[4].Direction = ParameterDirection.Output;

            string nombreProcedure = "SFC_ENTIDAD_RECAUDADORA_PKG.UPDATEENTIDADRECAUDADORA";
            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, nombreProcedure, arrayParam);
                //result = arrayParam[5].Value.ToString();
                //if (result != "0")
                //    throw new Exception(result);
            }
            catch (OracleException ex)
            {
                throw ex;
            }
        }
        #endregion
    }
}
