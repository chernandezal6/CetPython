using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class EntidadRepository : Framework.BaseObject<Entidad>, Framework.IBaseRepository<Entidad>
    {
        public EntidadRepository() : base() { }
        public EntidadRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Entidad GetByIdEntidad(int id)
        {
            return db.Entidades.FirstOrDefault(x => x.IdEntidad == id);
        }

        public Entidad GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
