using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class SectorSalarialRepository : Framework.BaseObject<Models.SectorSalarial>, Framework.IBaseRepository<Models.SectorSalarial>
    {
        public SectorSalarialRepository() : base() { }
        public SectorSalarialRepository(Framework.OracleDbContext context) : base(context) { }

        public SectorSalarial GetByIdSector(int id)
        {
            return db.SectoresSalariales.FirstOrDefault(x => x.Sector == id);   
        }

        public SectorSalarial GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
