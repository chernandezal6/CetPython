using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class MovimientoRepository : Framework.BaseObject<Models.Movimiento>, Framework.IBaseRepository<Models.Movimiento>
    {
        public MovimientoRepository() : base() { }
        public MovimientoRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Movimiento GetById(int id)
        {
            throw new NotImplementedException();
        }
        public Movimiento GetByIdMovimiento(int id)
        {
            return db.Movimientos.FirstOrDefault(x => x.IdMovimiento == id);
        }
    }
}
