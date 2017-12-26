using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class AdministracionLocalRepository : Framework.BaseObject<Models.AdministracionLocal>, Framework.IBaseRepository<Models.AdministracionLocal>
    {
        public AdministracionLocalRepository() : base() { }
        public AdministracionLocalRepository(Framework.OracleDbContext context) : base(context) { }

        public AdministracionLocal GetByIdAdministracionLocal(string id)
        {
            return db.AdministracionLocal.FirstOrDefault(x => x.IdAdministracionLocal == id);
        }

        public AdministracionLocal GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
