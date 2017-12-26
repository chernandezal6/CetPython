using System;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;

namespace ConsumirWebServiceNUIs.Clase
{
    public class dbConexion
    {
        private SqlConnection _sqlconexion = (SqlConnection)null;
        public InfoConexion InfoCon;

        public string Mensaje { get; set; }

        public SqlConnection SqlConexion
        {
            get
            {
                return this._sqlconexion;
            }
        }

        public dbConexion()
        {
        }

        public dbConexion(InfoConexion InfoCon)
        {
            this.InfoCon = InfoCon;
        }

        public SqlCommand SqlComando(CommandType TipoComando)
        {
            SqlCommand sqlCommand = new SqlCommand();
            sqlCommand.CommandType = TipoComando;
            sqlCommand.Connection = this._sqlconexion;
            return sqlCommand;
        }

        public void Desconectar()
        {
            if (this._sqlconexion == null)
                return;
            SqlConnection.ClearPool(this._sqlconexion);
            this._sqlconexion.Close();
            this._sqlconexion.Dispose();
            this._sqlconexion = (SqlConnection)null;
        }

        public bool Conectado()
        {
            if (this._sqlconexion == null)
                this.ConectarDb();
            return this._sqlconexion.State == ConnectionState.Open;
        }

        public bool ConectarDb()
        {
            bool flag = false;
            string connectionString = string.Format("Data Source ={0}; Initial Catalog={1}; User Id = {2}; Password = {3};Application Name={4};MultipleActiveResultSets=True;Packet Size=32767", (object)this.InfoCon.Server, (object)this.InfoCon.BaseDatos, (object)this.InfoCon.Usuario, (object)this.InfoCon.Clave, (object)Assembly.GetEntryAssembly().GetName().Name);
            try
            {
                if (this._sqlconexion == null)
                    this._sqlconexion = new SqlConnection(connectionString);
                if (this._sqlconexion.State != ConnectionState.Open)
                {
                    this._sqlconexion.Close();
                    this._sqlconexion.ConnectionString = connectionString;
                    this._sqlconexion.Open();
                }
                flag = this._sqlconexion.State == ConnectionState.Open;
            }
            catch (Exception ex)
            {
                this._sqlconexion.Dispose();
                this._sqlconexion = (SqlConnection)null;
                this.Mensaje = ex.Message;
            }
            return flag;
        }
    }

    public struct InfoConexion
    {
        public string Server { get; set; }

        public string BaseDatos { get; set; }

        public string Usuario { get; set; }

        public string Clave { get; set; }
    }
}
