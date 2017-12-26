using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class TipoNSSRepository : Framework.BaseObject<TipoNSS>, Framework.IBaseRepository<TipoNSS>
    {
        public TipoNSSRepository() : base() { }
        public TipoNSSRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public TipoNSS GetByIdTipoNSS(int id)
        {
            return db.TiposNss.FirstOrDefault(x => x.IdTipoNSS == id);
        }

        public TipoNSS GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
