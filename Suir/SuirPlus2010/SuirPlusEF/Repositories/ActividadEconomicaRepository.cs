using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ActividadEconomicaRepository : Framework.BaseObject<Models.ActividadEconomica>, Framework.IBaseRepository<Models.ActividadEconomica>
    {
        public ActividadEconomicaRepository() : base() { }
        public ActividadEconomicaRepository(Framework.OracleDbContext context) : base(context) { }

        public ActividadEconomica GetByIdActividadEconomica(string id)
        {
            return db.ActividadEconomica.FirstOrDefault(x => x.IdActividadEconomica == id);
        }

        public ActividadEconomica GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
