using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{

    public class OficioRepository : Framework.BaseObject<Oficio>, Framework.IBaseRepository<Oficio>
    {


        public Oficio GetById(int id)
        {
            throw new NotImplementedException();
        }
        public Oficio GetByIdOficio(int id)
        {
            return db.Oficios.FirstOrDefault(x => x.IdOficio == id);
        }       
        
    }
}
