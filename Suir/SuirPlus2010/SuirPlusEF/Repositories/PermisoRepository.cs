using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class PermisoRepository : Framework.BaseObject<Models.Permiso>, Framework.IBaseRepository<Models.Permiso>
    {
         public PermisoRepository() : base() { }
         public PermisoRepository(Framework.OracleDbContext contexto) : base(contexto) { }

         public Permiso GetByIdPermiso(int id)
         {
             return db.Permisos.FirstOrDefault(x => x.IdPermiso == id);
         }
        public Permiso GetById(int id)
        {
            return db.Permisos.FirstOrDefault(x => x.IdPermiso == id);
        }
    }
}
