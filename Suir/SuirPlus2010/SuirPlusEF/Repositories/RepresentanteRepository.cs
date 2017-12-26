using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class RepresentanteRepository : Framework.BaseObject<Models.Representante>, Framework.IBaseRepository<Models.Representante>
    {
        public RepresentanteRepository() : base() { }
        public RepresentanteRepository(Framework.OracleDbContext context) : base(context) { }     

        public Representante GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
