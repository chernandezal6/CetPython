using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace CrudWebApp.Models
{
    public class logicadenogocio
    {
        private String connectionString = ConfigurationManager.ConnectionStrings["dbCrud"].ConnectionString;

        public void Add(Contact d)
        {
            SqlConnection connstr = new SqlConnection(connectionString);
            try
            { 
            
                SqlCommand cmd = new SqlCommand("sp_insertContact", connstr);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@nombres", SqlDbType.NVarChar, 50).Value = d.nombres;
                cmd.Parameters.Add("@contaco", SqlDbType.NVarChar, 50).Value = d.contaco;
                cmd.Parameters.Add("@email", SqlDbType.NVarChar, 50).Value = d.email;
                cmd.Parameters.Add("@fecha_reg", SqlDbType.DateTime).Value = d.fecha_reg;
                connstr.Open();
                cmd.ExecuteNonQuery();
            }
            catch(Exception)
            {
                throw;
            }
            finally
            {
                connstr.Close();
            }



        }
        
    }
}