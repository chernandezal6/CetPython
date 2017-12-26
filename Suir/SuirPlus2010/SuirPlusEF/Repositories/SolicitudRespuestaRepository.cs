using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class SolicitudRespuestaRepository: Framework.BaseObject<Models.SolicitudRespuesta>, Framework.IBaseRepository<Models.SolicitudRespuesta>
    {
        public SolicitudRespuestaRepository() : base() { }
        public SolicitudRespuestaRepository(Framework.OracleDbContext context) : base(context) { }

        public SolicitudRespuesta GetByIdRespuesta(string id)
        {
            return db.SolicitudRespuesta.FirstOrDefault(x => x.IdRespuesta == id);
        }

        public SolicitudRespuesta GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
