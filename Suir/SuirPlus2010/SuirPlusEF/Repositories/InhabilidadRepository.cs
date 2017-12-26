using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class InhabilidadRepository : Framework.BaseObject<Models.InhabilidadJCE>,  Framework.IBaseRepository<Models.InhabilidadJCE>
    {
        public InhabilidadRepository() : base() { }
        public InhabilidadRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public InhabilidadJCE GetById(int id)
        {
            throw new NotImplementedException();
        }
        public InhabilidadJCE GetByIdInhabilidad(int id)
        {
            return db.Inhabilidad.FirstOrDefault(x => x.IdCausaInhabilidad == id);        }
    }
}
