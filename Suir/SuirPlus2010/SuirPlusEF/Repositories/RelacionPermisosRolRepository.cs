using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class RelacionPermisosRolRepository : Framework.BaseObject<Models.RelacionPermisosRol>, Framework.IBaseRepository<Models.RelacionPermisosRol>
    {
        public RelacionPermisosRolRepository() : base() { }
        public RelacionPermisosRolRepository(Framework.OracleDbContext context) : base(context) { }

        public RelacionPermisosRol GetByIdPermiso(int id)
        {
            return db.RelacionPermisosRoles.FirstOrDefault(x => x.IdPermiso == id);
        }

        public RelacionPermisosRol GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
