using SuirPlusEF.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class MaestroExtranjerosRepository : Framework.BaseObject<Models.MaestroExtranjero>, Framework.IBaseRepository<Models.MaestroExtranjero>
    {
        public MaestroExtranjerosRepository() : base() { }
        public MaestroExtranjerosRepository(Framework.OracleDbContext context) : base(context) { }
        

        public MaestroExtranjero GetByIdExpediente(string id)
        {
            return db.MaestroExtranjeros.FirstOrDefault(x => x.IdExpediente == id && x.IdNSSAsignado != null );
        }
        public MaestroExtranjero GetExtranjero(string id, string Tipo)
        {
            return db.MaestroExtranjeros.FirstOrDefault(x => x.IdExpediente == id && x.IdTipoDocumento == Tipo);
        }

        public MaestroExtranjero GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}