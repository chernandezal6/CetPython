using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories 
{
    public class FacturasRepository : Framework.BaseObject<Factura>, Framework.IBaseRepository<Factura>
    {

        public Factura GetByIdReferencia(string Id) {
            return db.Facturas.FirstOrDefault(x => x.IdReferencia == Id);
        }
        
        public Factura GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
