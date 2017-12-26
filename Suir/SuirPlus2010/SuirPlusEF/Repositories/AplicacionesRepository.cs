using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class AplicacionesRepository : Framework.BaseObject<Models.Aplicacion>, Framework.IBaseRepository<Models.Aplicacion>
    {
        public AplicacionesRepository() : base() { }
        public AplicacionesRepository(Framework.OracleDbContext context) : base(context) { }

        public Aplicacion GetByIdAplicacion(string id)
        {
            return db.Aplicaciones.FirstOrDefault(x => x.IdAplicacion == id);
        }

        public Aplicacion GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
