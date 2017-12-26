using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class MunicipioRepository : Framework.BaseObject<Models.Municipio>, Framework.IBaseRepository<Models.Municipio>
    {
        public MunicipioRepository() : base() { }
        public MunicipioRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Municipio GetById(int id)
        {
            throw new NotImplementedException();
        }
        public Municipio GetByIdMunicipio(string id)
        {
            return db.Municipio.FirstOrDefault(x => x.IdMunicipio == id);
        }
    }
}
