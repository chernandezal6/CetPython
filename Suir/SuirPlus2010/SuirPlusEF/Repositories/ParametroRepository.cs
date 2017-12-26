using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ParametroRepository : Framework.BaseObject<Models.Parametro>, Framework.IBaseRepository<Models.Parametro>
    {
        public ParametroRepository() : base() { }
        public ParametroRepository(Framework.OracleDbContext context) : base(context) { }

        public Parametro GetByIdParametro(int id)
        {
            return db.Parametros.FirstOrDefault(x => x.IdParametro == id);
        }

        public Parametro GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
