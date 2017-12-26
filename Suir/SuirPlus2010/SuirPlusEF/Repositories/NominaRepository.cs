using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class NominaRepository : Framework.BaseObject<Models.Nomina>, Framework.IBaseRepository<Nomina>
    {
        public NominaRepository() : base() { }
        public NominaRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Nomina GetById(int id)
        {
            throw new NotImplementedException();
        }
        public Nomina GetByIdNomina(int id)
        {
            return db.Nominas.FirstOrDefault(x => x.IdNomina == id);
        }
    }
}
