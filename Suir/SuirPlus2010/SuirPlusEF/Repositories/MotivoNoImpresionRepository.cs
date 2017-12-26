using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class MotivoNoImpresionRepository : Framework.BaseObject<Models.MotivoNoImpresion>, Framework.IBaseRepository<Models.MotivoNoImpresion>
    {
        public MotivoNoImpresionRepository() : base() { }
        public MotivoNoImpresionRepository(Framework.OracleDbContext context) : base(context) { }

        public MotivoNoImpresion GetByIdMotivo(string id)
        {
            return db.MotivoNoImpresion.FirstOrDefault(x => x.IdMotivoNoImpresion == id);
        }

        public MotivoNoImpresion GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
