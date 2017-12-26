using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class ProvinciaRepository : Framework.BaseObject<Models.Provincia>, Framework.IBaseRepository<Models.Provincia>
    {
        public ProvinciaRepository() : base() { }
        public ProvinciaRepository(Framework.OracleDbContext context) : base(context) { }

        public Provincia GetById(int id)
        {
            throw new NotImplementedException();
        }
        public Provincia GetByIdProvincia(string id)
        {
            return db.Provincias.FirstOrDefault(x => x.IdProvincia == id);
        }
    }
}
