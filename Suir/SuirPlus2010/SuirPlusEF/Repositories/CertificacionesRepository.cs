using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class CertificacionesRepository : Framework.BaseObject<Models.Certificaciones>, Framework.IBaseRepository<Models.Certificaciones>
    {
        public CertificacionesRepository() : base() { }
        public CertificacionesRepository(Framework.OracleDbContext context) : base(context) { }

        public Certificaciones GetByIdCertificacion(int idCertificacion)
        {
            return db.Certificaciones.FirstOrDefault(x => x.IdCertificacion == idCertificacion);
        }

        public Certificaciones GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
