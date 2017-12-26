using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class CategoriaRiesgoRepository : Framework.BaseObject<Models.CategoriaRiesgo>, Framework.IBaseRepository<Models.CategoriaRiesgo>
    {
        public CategoriaRiesgoRepository() : base() { }
        public CategoriaRiesgoRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public CategoriaRiesgo GetById(int id)
        {
            throw new NotImplementedException();
        }
        public CategoriaRiesgo GetByIdRiesgo(string id)
        {
            return db.CategoriaRiesgo.FirstOrDefault(x => x.IdRiesgo == id);

        }
    }
}
