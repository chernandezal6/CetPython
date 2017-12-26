using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ArsCarteraSenasaRepository : Framework.BaseObject<Models.ArsCarteraSenasa>, Framework.IBaseRepository<Models.ArsCarteraSenasa>
    {
        public ArsCarteraSenasaRepository() : base() { }
        public ArsCarteraSenasaRepository(Framework.OracleDbContext context) : base(context) { }

        public ArsCarteraSenasa GetByCodigoARS(int id)
        {
            return db.ArsCarterasSenasa.FirstOrDefault(x => x.CodigoArs == id);
        }

        public ArsCarteraSenasa GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
