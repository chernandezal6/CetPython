using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class LogRepository : Framework.BaseObject<Models.Log>, Framework.IBaseRepository<Models.Log>
    {

        public LogRepository() : base() { }
        public LogRepository(Framework.OracleDbContext contexto) : base(contexto) { }
        
        public Log GetById(int id)
        {
            return db.Logs.FirstOrDefault(x => x.Id == id);
        }
    }
}
