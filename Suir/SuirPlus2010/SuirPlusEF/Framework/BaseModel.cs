using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Framework
{
    public abstract class BaseModel
    {
        public string myOracleSequenceName;
        public int myOracleNextSequence;
        public BaseModel()
        {
            this.myOracleNextSequence = 0;
        }

        public abstract int AssignId(int id); 

        public void GetNextSequence()
        {
            //para pasar parametros a un stored procedure oracle, se necesita definirlos como se muestra a continuación.
            
            //parametros de entrada
            Oracle.ManagedDataAccess.Client.OracleParameter p_sequence_name = new Oracle.ManagedDataAccess.Client.OracleParameter();
            p_sequence_name.ParameterName = "p_sequence_name";
            p_sequence_name.Value = myOracleSequenceName;
            p_sequence_name.Direction = System.Data.ParameterDirection.Input;
            p_sequence_name.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2;

            //parametro de salida
            Oracle.ManagedDataAccess.Client.OracleParameter p_sequence_value = new Oracle.ManagedDataAccess.Client.OracleParameter();
            p_sequence_value.ParameterName = "p_sequence_value";
            p_sequence_value.Direction = System.Data.ParameterDirection.Output;
            p_sequence_value.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Int32;

            //parametro de salida
            Oracle.ManagedDataAccess.Client.OracleParameter p_resultnumber = new Oracle.ManagedDataAccess.Client.OracleParameter();
            p_resultnumber.ParameterName = "p_resultNumber";
            p_resultnumber.Direction = System.Data.ParameterDirection.Output;
            p_resultnumber.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2;
            p_resultnumber.Size = 500;
            
                OracleDbContext db = new OracleDbContext();
                db.Database.ExecuteSqlCommand("begin NEXT_SEQUENCE(:p_sequence_name,:p_sequence_value,:p_resultNumber); end;", p_sequence_name, p_sequence_value, p_resultnumber);

            if (p_resultnumber.Value.ToString() == "OK")
            {
                this.myOracleNextSequence = Convert.ToInt32(p_sequence_value.Value.ToString());
            }
            else
            {
                string[] resultException = p_resultnumber.Value.ToString().Split('|');
                throw new Exception(resultException[1]);
            }

            this.AssignId(this.myOracleNextSequence);

        }
    }
}
