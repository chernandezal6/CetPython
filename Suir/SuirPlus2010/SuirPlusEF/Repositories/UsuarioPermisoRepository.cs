using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class UsuarioPermisoRepository : Framework.BaseObject<Models.UsuarioPermiso>, Framework.IBaseRepository<Models.UsuarioPermiso>
    {
        public UsuarioPermisoRepository() : base() { }
        public UsuarioPermisoRepository(Framework.OracleDbContext context) : base(context) { }

        public UsuarioPermiso GetByIdPermiso(int id)
        {
            return db.UsuarioPermisos.FirstOrDefault(x => x.IdPermiso == id);
        }
        public UsuarioPermiso GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
