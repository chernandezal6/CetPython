using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class LiquidacionISRRepository : Framework.BaseObject<LiquidacionISR>, Framework.IBaseRepository<LiquidacionISR>
    {
        public LiquidacionISR GetIdReferenciaISR(string Id)
        {
            return db.LiquidacionesISR.FirstOrDefault(x => x.IdReferenciaISR == Id);
        }

        public LiquidacionISR GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
