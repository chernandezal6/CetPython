using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ArchivoRepository : Framework.BaseObject<Models.Archivo>, Framework.IBaseRepository<Models.Archivo>
    {
        public ArchivoRepository() : base() { }
        public ArchivoRepository(Framework.OracleDbContext context) : base(context) { }

        public Archivo GetByIdRecepcion(int id)
        {
            return db.Archivos.FirstOrDefault(x => x.IdRecepcion == id);
        }

        public Archivo GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
