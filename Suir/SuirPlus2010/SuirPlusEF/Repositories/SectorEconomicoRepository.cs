using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class SectorEconomicoRepository : Framework.BaseObject<Models.SectorEconomico>, Framework.IBaseRepository<Models.SectorEconomico>
    {
        public SectorEconomicoRepository() : base() { }
        public SectorEconomicoRepository(Framework.OracleDbContext context) : base(context) { }

        public SectorEconomico GetByIdSectorEconomico(int id)
        {
            return db.SectoresEconomicos.FirstOrDefault(x => x.IdSectorEconomico == id);
        }

        public SectorEconomico GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
