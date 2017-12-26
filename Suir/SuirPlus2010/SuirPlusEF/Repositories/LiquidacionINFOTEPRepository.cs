using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class LiquidacionInfotepRepository : Framework.BaseObject<LiquidacionInfotep>, Framework.IBaseRepository<LiquidacionInfotep>
    {
        public LiquidacionInfotep GetByIdReferenciaInfotep(string Id) 
        {
            return db.LiquidacionesInfotep.FirstOrDefault(x => x.IdReferenciaInfotep == Id);
        }

        public LiquidacionInfotep GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
