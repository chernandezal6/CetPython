using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class MotivoRepository : Framework.BaseObject<Motivo>, Framework.IBaseRepository<Motivo>
    {
        public MotivoRepository() : base() { }
        public MotivoRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Motivo GetByIdMotivo(int id)
        {
            return db.Motivos.FirstOrDefault(x => x.IdMotivo == id);
        }

        public Motivo GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
