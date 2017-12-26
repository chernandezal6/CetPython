using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class AccionRepository : Framework.BaseObject<Models.Accion>, Framework.IBaseRepository<Models.Accion>
    {
        public AccionRepository() : base() { }
        public AccionRepository(Framework.OracleDbContext context) : base(context) { }

        public Accion GetByIdAccion(int id)
        {
            return db.Acciones.FirstOrDefault(x => x.IdAccion == id); 
        }

        public Accion GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
