using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
  public  class ArsCarteraRepository : Framework.BaseObject<ArsCartera>, Framework.IBaseRepository<ArsCartera>
    {
      public ArsCarteraRepository() : base() { }
      public ArsCarteraRepository(Framework.OracleDbContext context) : base(context) { }

        public ArsCartera GetByPeriodoFacturaARS(string id)
        {
            return db.ArsCarteras.FirstOrDefault(x => x.PeriodoFacturaArs == id);
        }

        public ArsCartera GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
