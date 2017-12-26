using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Framework;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ParentescoRepository : Framework.BaseObject<Models.Parentesco>, Framework.IBaseRepository<Models.Parentesco>
    {
        public ParentescoRepository() : base() { }
        public ParentescoRepository(Framework.OracleDbContext context) : base(context) { }

        public Parentesco GetById(int id)
        {
            throw new NotImplementedException();
        }

        public Parentesco GetByIdParentesco(string id)
        {
            return db.Parentescos.FirstOrDefault(x => x.IdParentesco == id);
        }

    }
}
