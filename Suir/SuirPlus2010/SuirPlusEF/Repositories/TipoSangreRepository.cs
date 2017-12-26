using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace SuirPlusEF.Repositories
{
    public class TipoSangreRepository : Framework.BaseObject<Models.TipoSangre>, Framework.IBaseRepository<Models.TipoSangre>
                         
    {

        public TipoSangreRepository() : base() { }
        public TipoSangreRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public TipoSangre GetById(int id)
        {
            throw new NotImplementedException();
        }

        public TipoSangre GetByIdTipoSangre(string IdTipoSangre)
        {
            return db.TipoSangre.FirstOrDefault(x => x.IdTipoSangre == IdTipoSangre);
        }


    }
}
