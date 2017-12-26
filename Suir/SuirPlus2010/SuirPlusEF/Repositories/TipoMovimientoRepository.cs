using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class TipoMovimientoRepository : Framework.BaseObject<Models.TipoMovimiento>, Framework.IBaseRepository<Models.TipoMovimiento>
    {
        public TipoMovimientoRepository() : base() { }
        public TipoMovimientoRepository(Framework.OracleDbContext context) : base(context) { }

        public TipoMovimiento GetByIdTipoMovimiento(string id)
        {
            return db.TiposMovimientos.FirstOrDefault(x => x.IdTipoMovimiento == id);
        }

        public TipoMovimiento GetById(int id)
        {
            throw new NotImplementedException();
        }

    }
}
