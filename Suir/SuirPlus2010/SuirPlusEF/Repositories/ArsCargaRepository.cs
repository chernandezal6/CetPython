using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ArsCargaRepository : Framework.BaseObject<Models.ArsCarga>, Framework.IBaseRepository<Models.ArsCarga>
    {
        public ArsCargaRepository() : base() { }
        public ArsCargaRepository(Framework.OracleDbContext context) : base(context) { }

        public ArsCarga GetByIdCarga(int id)
        {
            return db.ArsCargas.FirstOrDefault(x => x.IdCarga == id); 
        }

        public ArsCarga GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
