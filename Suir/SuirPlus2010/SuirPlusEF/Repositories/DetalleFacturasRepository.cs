using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class DetalleFacturasRepository : Framework.BaseObject<DetalleFactura>, Framework.IBaseRepository<DetalleFactura>
    {
        public DetalleFactura GetByIdReferencia(string Id)
        {
            return db.DetalleFacturas.FirstOrDefault(x => x.IdReferencia == Id);
        }

        public DetalleFactura GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
