using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class RenglonRepository : Framework.BaseObject<Models.Renglon>, Framework.IBaseRepository<Models.Renglon>
    {
        public RenglonRepository() : base() { }
        public RenglonRepository(Framework.OracleDbContext context) : base(context) { }

        public Renglon GetByIdRenglon(string id)
        {
            return db.Renglones.FirstOrDefault(x => x.IdRenglon == id);
        }

        public Renglon GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
