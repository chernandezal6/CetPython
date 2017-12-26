using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class DetalleLiquidacionISRRepository : Framework.BaseObject<DetalleLiquidacionISR>, Framework.IBaseRepository<DetalleLiquidacionISR>
    {
        public DetalleLiquidacionISR GetByIdReferenciaISR(string Id)
        {
            return db.DetalleLiquidacionesISR.FirstOrDefault(x => x.IdReferenciaISR == Id);
        }

        public DetalleLiquidacionISR GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
