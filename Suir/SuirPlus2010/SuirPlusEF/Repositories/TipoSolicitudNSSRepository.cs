using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class TipoSolicitudNSSRepository : Framework.BaseObject<TipoSolicitudNSS>, Framework.IBaseRepository<TipoSolicitudNSS>
    {
        public TipoSolicitudNSSRepository() : base() { }
        public TipoSolicitudNSSRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public TipoSolicitudNSS GetByIdTipoSolNSS(Int32 id)
        {
            return db.TipoSolicitudesNSS.FirstOrDefault(x => x.IdTipo == id);
        }

        public IList<TipoSolicitudNSS> GetTipoSolicitud()
        {
            return db.TipoSolicitudesNSS.ToList();
        }
        public TipoSolicitudNSS GetById(int id)
        {
            throw new NotImplementedException();
        }

    }
}
