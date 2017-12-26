using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class DetalleLiquidacionInfotepRepository : Framework.BaseObject<DetalleLiquidacionInfotep>, Framework.IBaseRepository<DetalleLiquidacionInfotep>
    {
        public DetalleLiquidacionInfotep GetByIdReferenciaInfotep(string Id)
        {
            return db.DetalleLiquidacionesInfotep.FirstOrDefault(x => x.IdReferenciaInfotep == Id);
        }

        public DetalleLiquidacionInfotep GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
