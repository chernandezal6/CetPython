using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ConfigRepository : Framework.BaseObject<Config>, Framework.IBaseRepository<Config>
    {
        public ConfigRepository() : base() { }
        public ConfigRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Config GetByIdModulo(string id)
        {
            return db.Configs.FirstOrDefault(x => x.IdModulo == id);
        }

        public Config GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
