using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class OficioDocumentacionRepository : Framework.BaseObject<OficioDocumentacion>, Framework.IBaseRepository<OficioDocumentacion>
    {
        public OficioDocumentacion GetByIdDocumento(int id)
        {
            return db.OficioDocumentacion.FirstOrDefault(x => x.IdDocumento == id);
        }

        public OficioDocumentacion GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
