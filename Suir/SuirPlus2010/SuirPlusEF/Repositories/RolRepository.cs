using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;
using System.Data.Entity.Infrastructure;

namespace SuirPlusEF.Repositories
{
    public class RolRepository : Framework.BaseObject<Models.Rol>, Framework.IBaseRepository<Models.Rol>
    {
         public RolRepository() : base() { }
         public RolRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Rol GetById(int id)
        {
            return db.Roles.FirstOrDefault(x => x.IdRole == id);
        }

    }
}
