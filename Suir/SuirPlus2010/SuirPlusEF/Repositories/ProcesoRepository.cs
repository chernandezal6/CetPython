using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ProcesoRepository : Framework.BaseObject<Models.Proceso>, Framework.IBaseRepository<Models.Proceso>
    {
         public ProcesoRepository() : base() { }
         public ProcesoRepository(Framework.OracleDbContext contexto) : base(contexto) { }

         public Proceso GetById(int id)
         {
             throw new NotImplementedException();
         }

         public Proceso GetByIdProceso(string id)
         {
             return db.Procesos.FirstOrDefault(x => x.IdProceso == id);
         }


    }
}
