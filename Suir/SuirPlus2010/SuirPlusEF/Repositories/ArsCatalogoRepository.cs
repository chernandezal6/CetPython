using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ArsCatalogoRepository : Framework.BaseObject<ArsCarteraSenasa>, Framework.IBaseRepository<ArsCarteraSenasa>
    {
        public ArsCatalogo GetByIdArs(int id)
        {
            return db.ArsCatalogos.FirstOrDefault(x => x.IdArs == id);
        }

        public ArsCarteraSenasa GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
