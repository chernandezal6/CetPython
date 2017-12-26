using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class BitacoraRepository : Framework.BaseObject<Models.Bitacora>, Framework.IBaseRepository<Models.Bitacora>
    {
          public BitacoraRepository() : base() { }
          public BitacoraRepository(Framework.OracleDbContext contexto) : base(contexto) { }

          public Bitacora GetById(int id)
          {
              return db.Bitacoras.FirstOrDefault(x => x.IdBitacora == id);
          }
    }
}
