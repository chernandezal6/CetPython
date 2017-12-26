using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
       
    public class DetalleOficiosRepository : Framework.BaseObject<DetalleOficios>, Framework.IBaseRepository<DetalleOficios>
               
        {
        public DetalleOficios GetByIdOficio(int id)
        {
            return db.DetalleOficios.FirstOrDefault(x => x.IdOficio == id);
        }

        public DetalleOficios GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
