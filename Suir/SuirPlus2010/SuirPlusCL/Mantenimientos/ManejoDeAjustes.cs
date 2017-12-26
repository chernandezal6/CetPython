using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SuirPlus;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;

namespace SuirPlus.Mantenimientos
{
    public class ManejoDeAjustes
    {
        //#region Miembros y Propiedades Manejo de Ajustes

        //private int mId;
        //private int mIdRegistroPatronal;
        //private int mIdNomina;
        //private int mPeriodo;
        //private int mIdNSS;
        //private AjusteType mTipoAjuste; //Tipo de Ajuste 1 ='Maternidad', 2 = 'Lactancia'
        //private string mEstatus; //PE = 'Pendiente', GE = 'Generado', 'AP' = Aplicado, CA = 'Cancelado'
        //private int mMontoAjuste;
        //private DateTime mFechaRegistro;
        //private DateTime mFechaGeneracion;
        //private int mIdReferencia;
        //private DateTime mFechaAplicacion;
        //private DateTime mFechaCancelacion;
        //private string mUnico; //ROWID de Elegibles
        //private string mNroPago;


        //public int IdAjuste
        //{
        //    get { return mId; }
        //}

        //public int IdRegistroPatronal
        //{
        //    get
        //    {
        //        return this.mIdRegistroPatronal;
        //    }
           
        //}

        //public int IdNomina
        //{
        //    get
        //    {
        //        return this.mIdNomina;
        //    }
            
        //}

        //public int Periodo
        //{
        //    get { return mPeriodo; }
        //}

        //public int IdNSS
        //{
        //    get { return mIdNSS; }
        //}

        //public int IdReferencia
        //{
        //    get { return mIdReferencia; }
        //}

        //public AjusteType TipoAjuste
        //{
        //    get
        //    {
        //        return this.mTipoAjuste;
        //    }
        //}

        //public string Estatus
        //{
        //    get
        //    {
        //        return this.mEstatus;
        //    }
        //}

        //public int MontoAjuste
        //{
        //    get
        //    {
        //        return this.mMontoAjuste;
        //    }
        //}

        //public DateTime FechaRegistro
        //{
        //    get
        //    {
        //        return this.mFechaRegistro;
        //    }

        //}

        //public DateTime FechaGeneracion
        //{
        //    get
        //    {
        //        return this.mFechaGeneracion;
        //    }
        //}

        //public DateTime FechaAplicacion
        //{
        //    get
        //    {
        //        return this.mFechaAplicacion;
        //    }

        //}

        //public DateTime FechaCancelacion
        //{
        //    get
        //    {
        //        return this.mFechaAplicacion;
        //    }

        //}

        //public string Unico
        //{
        //    get{ return this.mUnico;}
        //}

        //public string NroPago
        //{
        //    get{ return this.mNroPago;}
        //}
        

        //#endregion

        #region Miembros y Propiedades Tipo de Ajustes

        private int tIdTipoAjuste;
        private string tDescripcion;
        private string tTipoMovimiento;
        private string tEstatus;
        private int tCuentaOrigen;
        private int tCuentaDestino;
        private DateTime tUltFechaAct;
        private string tUltUsuarioAct;
        
        public int IdTipoAjuste
        {
            get { return tIdTipoAjuste; }
        }
        public string Descripcion
        {
            get{return tDescripcion;}
            set{tDescripcion = value;}
        }
        public string TipoMovimiento
        {
            get { return tTipoMovimiento;}
            set { tTipoMovimiento = value;}
        }
        public string Estatus
        {
            get { return tEstatus; }
            set { tEstatus = value; }
        }
        public int CuentaOrigen
        {
            get { return tCuentaOrigen; }
            set { tCuentaOrigen = value; }
        }
        public int CuentaDestino
        {
            get { return tCuentaDestino; }
            set { tCuentaDestino = value; }
        }        
        public DateTime UltFechaAct
        {
            get { return tUltFechaAct; }
            set { tUltFechaAct = value; }
        }
        public string UltUsuarioAct
        {
            get { return tUltUsuarioAct; }
            set { tUltUsuarioAct = value; }
        }

        #endregion

        public enum AjusteType
        {
            Maternidad,
            Lactancia
        }

        //Constructores
        public ManejoDeAjustes(int IdTipoAjuste)
        {
            this.tIdTipoAjuste = IdTipoAjuste;
            this.CargarDatos();
            
        }

        public void CargarDatos()
        {
       
            DataTable dtTipoAjuste = this.getTipoAjuste();
	
            if(dtTipoAjuste.Rows.Count > 0)
            {
                try
                {
                    this.tIdTipoAjuste = Convert.ToInt32(dtTipoAjuste.Rows[0]["id_tipo_ajuste"]);
                    this.tDescripcion = dtTipoAjuste.Rows[0]["descripcion"].ToString();
                    this.tTipoMovimiento = dtTipoAjuste.Rows[0]["tipo_movimiento"].ToString();
                    this.tEstatus = dtTipoAjuste.Rows[0]["estatus"].ToString();

                    if (dtTipoAjuste.Rows[0]["cuenta_origen"].ToString() != string.Empty)
                    {
                        this.tCuentaOrigen = Convert.ToInt32(dtTipoAjuste.Rows[0]["cuenta_origen"]);
                    }
                    
                    if (dtTipoAjuste.Rows[0]["cuenta_destino"].ToString() != string.Empty)
                    {
                        this.tCuentaDestino = Convert.ToInt32(dtTipoAjuste.Rows[0]["cuenta_destino"]);
                    }
                    
                    this.tUltFechaAct = Convert.ToDateTime(dtTipoAjuste.Rows[0]["ult_fecha_act"]);
                    this.tUltUsuarioAct = dtTipoAjuste.Rows[0]["ult_usuario_act"].ToString();
                   
                }
                catch(Exception ex)
                {
                 throw ex;
                }

            }
            else 
            
            {
                throw new Exception("No hay data.");
            }

        }

        public DataTable getTipoAjuste()
        {
           
                OracleParameter[] arrParam = new OracleParameter[3];

               arrParam[0] = new OracleParameter("p_idTipoAjuste", OracleDbType.Varchar2);
               arrParam[0].Value= this.tIdTipoAjuste;
               arrParam[1] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
               arrParam[1].Direction= ParameterDirection.Output;
               arrParam[2]= new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,1000);
               arrParam[2].Direction= ParameterDirection.Output;

               string cmdStr="sfc_ajustes_pkg.gettipoajuste";
               string result=string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();

                if (result != "0")
                {
                    string[] ErrorMsg = result.Split('|');
                    throw new Exception(ErrorMsg[1]);
                }

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

        public static DataTable getTipoAjustes()
        {
         
                OracleParameter[] arrParam = new OracleParameter[2];

               arrParam[0] = new OracleParameter("p_cursor", OracleDbType.RefCursor);
               arrParam[0].Direction= ParameterDirection.Output;
               arrParam[1]= new OracleParameter("p_resultnumber", OracleDbType.NVarchar2,1000);
               arrParam[1].Direction= ParameterDirection.Output;

               string cmdStr="sfc_ajustes_pkg.gettipoajustes";
               string result=string.Empty;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();

                if (result != "0")
                {
                    string[] ErrorMsg = result.Split('|');
                    throw new Exception(ErrorMsg[1]);
                }

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


        public static string actTipoAjuste(int id_tipo_ajuste, string  descripcion, string tipoMovimiento, string estatus,
                                        int cuentaOrigen, int cuentaDestino, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_id_tipo_ajuste", OracleDbType.Int32);
            arrParam[0].Value = id_tipo_ajuste;
            arrParam[1] = new OracleParameter("p_descripcion", OracleDbType.Varchar2);
            arrParam[1].Value = descripcion;
            arrParam[2] = new OracleParameter("p_tipo_movimiento", OracleDbType.NVarchar2);
            arrParam[2].Value = tipoMovimiento;
            arrParam[3] = new OracleParameter("p_status", OracleDbType.NVarchar2);
            arrParam[3].Value = estatus;
            arrParam[4] = new OracleParameter("p_cuenta_origen", OracleDbType.Int32);
            arrParam[4].Value = cuentaOrigen;
            arrParam[5] = new OracleParameter("p_cuenta_destino", OracleDbType.Int32);
            arrParam[5].Value = cuentaDestino;
            arrParam[6] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2, 35);
            arrParam[6].Value = usuario;
            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_ajustes_pkg.editartipoajuste";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[7].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }



    }
}
