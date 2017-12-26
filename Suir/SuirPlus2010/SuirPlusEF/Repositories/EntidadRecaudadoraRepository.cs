using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
   public class EntidadRecaudadoraRepository : Framework.BaseObject<EntidadRecaudadora>, Framework.IBaseRepository<EntidadRecaudadora>
    {
       public EntidadRecaudadora GetById(int id)
       {
           throw new NotImplementedException();
       }

        public EntidadRecaudadora GetByIdEntidadRecaudadora(int id)
        {
            return db.EntidadesRecaudadora.FirstOrDefault(x => x.IdEntidadRecaudadora == id);
        }
    }
}
