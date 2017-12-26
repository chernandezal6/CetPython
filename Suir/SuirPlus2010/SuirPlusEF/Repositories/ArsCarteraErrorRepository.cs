using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ArsCarteraErrorRepository : Framework.BaseObject<Models.ArsCarteraError>, Framework.IBaseRepository<Models.ArsCarteraError>
    {
        public ArsCarteraErrorRepository() : base() { }
        public ArsCarteraErrorRepository(Framework.OracleDbContext context) : base(context) { }

        public ArsCarteraError GetByIdError(int id)
        {
            return db.ArsCarteraErrores.FirstOrDefault(x => x.IdError == id);
        }

        public ArsCarteraError GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
